//
//  DataService.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 8/31/23.
//

import CoreData
import Foundation

class DataService: ObservableObject {
    
    let container = NSPersistentContainer(name: Keys.APPLICATION_NAME)
    let defaults = UserDefaults.standard
    
    init() {
        // Setting up container
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
        // Printing SQLite location for debugging
        let path = getSqlitePath()
        print("SQLite: \(path!)")
        
        // Checking if list of symptoms exists
        if (!isSymptomsPreloaded()) {
            preloadSymptoms()
        }
        
        // Setting up user session
        setUserSession()
    }
    
    func isSymptomsPreloaded() -> Bool {
        return defaults.string(forKey: Keys.LAST_USER_SESSION) != nil
    }
    
    func preloadSymptoms() -> Void {
        let moc = container.viewContext
        defaultSymptoms.forEach { id, name in
            let symptom = Symptom(context: moc)
            symptom.id = Int16(id)
            symptom.name = name
            try? moc.save()
        }
    }
    
    func setUserSession() -> Void {
        let moc = container.viewContext
        let session = Session(context: moc)
        session.uuid = UUID().uuidString
        session.timestamp = Date()
        try? moc.save()
        defaults.set(session.uuid, forKey: Keys.LAST_USER_SESSION)
    }
    
    func getSqlitePath() -> String? {
        return NSPersistentContainer
            .defaultDirectoryURL()
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding
    }
    
}
