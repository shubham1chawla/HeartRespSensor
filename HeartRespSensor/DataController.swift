//
//  DataController.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 8/31/23.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    
    let container = NSPersistentContainer(name: "HeartRespSensor")
    let defaults = UserDefaults.standard
    
    let defaultSymptoms = [
        1: "Fever",
        2: "Nausea",
        3: "Headache",
        4: "Diarrhea",
        5: "Soar Throat",
        6: "Muscle Ache",
        7: "Loss of Smell or Taste",
        8: "Cough",
        9: "Shortness of Breath",
        10: "Feeling Tired"
    ]
    
    init() {
        // Setting up container
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
        // Printing SQLite location for debugging
        logSqlitePath()
        
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
    
    func logSqlitePath() -> Void {
        let path = NSPersistentContainer
            .defaultDirectoryURL()
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding
        print("SQLite: \(path ?? "Not found")")
    }
    
}
