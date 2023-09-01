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
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
        // Checking if list of symptoms exists
        let moc = container.viewContext
        var symptoms: [Symptom]
        do {
            symptoms = try moc.fetch(Symptom.fetchRequest())
            print("Loaded \(symptoms.count) symptoms")
            if symptoms.isEmpty {
                preloadSymptoms(moc: moc)
            }
        } catch {
            print("Error loading symptoms")
        }
        
        // Printing SQLite location for debugging
        let path = NSPersistentContainer
            .defaultDirectoryURL()
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding
        print("SQLite: \(path ?? "Not found")")
    }
    
    func preloadSymptoms(moc: NSManagedObjectContext) {
        var i: Int16 = 1
        [
            "Fever",
            "Nausea",
            "Headache",
            "Diarrhea",
            "Soar Throat",
            "Muscle Ache",
            "Loss of Smell or Taste",
            "Cough",
            "Shortness of Breath",
            "Feeling Tired"
        ]
        .forEach { name in
            let symptom = Symptom(context: moc)
            symptom.id = i
            symptom.name = name
            try? moc.save()
            i += 1
        }
    }
}
