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
    
    @Published public var intensities = [Int:String]()
    
    init() {
        // Setting up container
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        
        // Printing SQLite location for debugging
        if defaults.bool(forKey: Keys.IS_DEVELOPER_MODE_ENABLED) {
            print("SQLite: \(getSqlitePath()!)")
        }
        
        // Checking if list of symptoms exists
        if (!isSymptomsPreloaded()) {
            preloadSymptoms()
        }
        
        // Loading default intensities
        preloadIntensities()
        
        // Setting up user session
        setUserSessionId()
    }
    
    private func getSqlitePath() -> String? {
        return NSPersistentContainer
            .defaultDirectoryURL()
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding
    }
    
    private func isSymptomsPreloaded() -> Bool {
        return defaults.string(forKey: Keys.LAST_USER_SESSION) != nil
    }
    
    private func preloadSymptoms() -> Void {
        // Loading the symptoms from the json file
        guard let path = Bundle.main.path(forResource: "symptoms", ofType: "json") else {
            fatalError("Couldn't load default symptoms!")
        }
        let defaultSymptoms: [DecodableSymptom] = loadFromJson(at: URL(filePath: path))
        
        // Saving the loaded symptoms
        let moc = container.viewContext
        defaultSymptoms.forEach { decodable in
            let symptom = Symptom(context: moc)
            symptom.id = Int16(decodable.id)
            symptom.name = decodable.name
            try? moc.save()
        }
    }
    
    private func preloadIntensities() -> Void {
        // Loading the intensities from the json file
        guard let path = Bundle.main.path(forResource: "intensities", ofType: "json") else {
            fatalError("Couldn't load default intensities!")
        }
        let defaultIntensities: [DecodableIntensity] = loadFromJson(at: URL(filePath: path))
        
        // Setting up intensities
        var intensities: [Int:String] = [:]
        defaultIntensities.forEach { decodable in
            intensities[decodable.value] = decodable.label
        }
        self.intensities = intensities
    }
    
    private func loadFromJson<T: Decodable>(at url: URL) -> [T] {
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func setUserSessionId() -> Void {
        defaults.set(UUID().uuidString, forKey: Keys.LAST_USER_SESSION)
    }
    
    private func getCurrentUserSession() -> UserSession {
        let sessionId = defaults.string(forKey: Keys.LAST_USER_SESSION)!
        
        // Creating the request
        let request = UserSession.fetchRequest()
        request.predicate = NSPredicate(format: "uuid CONTAINS %@", sessionId)
        
        // Fetching the user session
        let moc = container.viewContext
        let userSessions = try! moc.fetch(request)
        if userSessions.isEmpty {
            // Creating a new user session instance
            let userSession = UserSession(context: moc)
            userSession.timestamp = Date()
            userSession.uuid = sessionId
            return userSession
        }
        return userSessions.first!
    }
    
    func saveUserSymptom(symptom: Symptom, intensity: Int) -> Void {
        let moc = container.viewContext
        
        // Loading user session to check all existing symptoms
        let userSession = getCurrentUserSession()
        
        // Checking if the requested symptom is already recorded
        if let userSymptoms = userSession.userSymptoms {
            for object in userSymptoms {
                let userSymtom = object as! UserSymptom
                if userSymtom.symptom!.id == symptom.id {
                    userSymtom.intensity = Int16(intensity)
                    try? moc.save()
                    return
                }
            }
        }
        
        // Creating new user symptom if it is not previously record
        let userSymptom = UserSymptom(context: moc)
        userSymptom.symptom = symptom
        userSymptom.intensity = Int16(intensity)
        userSymptom.userSession = userSession
        
        // Saving the record
        try? moc.save()
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
