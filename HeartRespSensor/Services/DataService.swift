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
        setUserSessionId()
    }
    
    private func isSymptomsPreloaded() -> Bool {
        return defaults.string(forKey: Keys.LAST_USER_SESSION) != nil
    }
    
    private func preloadSymptoms() -> Void {
        let moc = container.viewContext
        defaultSymptoms.forEach { id, name in
            let symptom = Symptom(context: moc)
            symptom.id = Int16(id)
            symptom.name = name
            try? moc.save()
        }
    }
    
    private func setUserSessionId() -> Void {
        defaults.set(UUID().uuidString, forKey: Keys.LAST_USER_SESSION)
    }
    
    private func getSqlitePath() -> String? {
        return NSPersistentContainer
            .defaultDirectoryURL()
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding
    }
    
    func getCurrentUserSession() -> UserSession {
        let sessionId = defaults.string(forKey: Keys.LAST_USER_SESSION)!
        
        // Creating the request
        let request = UserSession.fetchRequest()
        request.predicate = NSPredicate(format: "uuid CONTAINS %@", sessionId)
        
        // Fetching the user session
        let moc = container.viewContext
        let userSessions = try! moc.fetch(request)
        if userSessions.isEmpty {
            let userSession = UserSession(context: moc)
            userSession.timestamp = Date()
            userSession.uuid = sessionId
            return userSession
        }
        return userSessions.first!
    }
    
    func saveUserSymptom(symptom: Symptom, intensity: Int) -> Void {
        let moc = container.viewContext
        
        // Creating user symptom instance
        let userSymptom = UserSymptom(context: moc)
        userSymptom.symptom = symptom
        userSymptom.intensity = Int16(intensity)
        userSymptom.userSession = getCurrentUserSession()
        
        // Saving the record
        try? moc.save()
    }
    
    func doesUserSessionContainsProperties(_ userSession: UserSession) -> Bool {
        var heartRate: Double = 0, respRate: Double = 0, userSymptomsCount: Int = 0
        if let sensorRecord = userSession.sensorRecord {
            heartRate = sensorRecord.heartRate
            respRate = sensorRecord.respRate
        }
        if let userSymptoms = userSession.userSymptoms {
            userSymptomsCount = userSymptoms.count
        }
        return heartRate > 0 || respRate > 0 || userSymptomsCount > 0
    }
    
    func saveSensorRecord(heartRate : Double, respRate: Double) -> Void {
        let moc = container.viewContext
        
        // Fetching user session record
        let userSession = getCurrentUserSession()
        let sensorRecord = userSession.sensorRecord ?? SensorRecord(context: moc)
        sensorRecord.heartRate = heartRate
        sensorRecord.respRate = respRate
        
        // Linking sensor record with user session
        sensorRecord.userSession = userSession
        
        // Saving the record
        try? moc.save()
    }
    
}
