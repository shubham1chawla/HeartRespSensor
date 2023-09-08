//
//  HistoryView.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 9/4/23.
//

import SwiftUI

struct HistoryView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "timestamp", ascending: false)]) var userSessions: FetchedResults<UserSession>
    
    struct History: Identifiable {
        let id = UUID()
        var name: String
        var icon: String
        var value: String?
        var items: [History]?
    }
    
    var body: some View {
        List(userSessions.map(getHistory), id: \.id, children: \.items) { row in
            HStack {
                Image(systemName: row.icon)
                Text(row.name)
                if row.value != nil {
                    Spacer()
                    Text(row.value!)
                }
            }
        }
        .navigationTitle("History")
    }
    
    private func getHistory(for userSession: UserSession) -> History {
        // Creating base history record from user session
        let timestamp = userSession.timestamp!
        var history = History(name: timestamp.formatted(), icon: "clock.arrow.circlepath")
        
        // Flattening the sensor record
        var items: [History] = []
        if let sensorRecord = userSession.sensorRecord {
            items.append(History(name: "Heart Rate", icon: "heart", value: String(format: "%.2f", sensorRecord.heartRate)))
            items.append(History(name: "Respiratory Rate", icon: "lungs", value: String(format: "%.2f", sensorRecord.respRate)))
        }
        
        // Flattening the user symptoms
        if let userSymptoms = userSession.userSymptoms {
            for element in userSymptoms {
                let userSymptom = element as! UserSymptom
                items.append(History(name: userSymptom.symptom!.name!, icon: "heart.text.square", value: String(userSymptom.intensity)))
            }
        }
        
        // Adding items to the history
        history.items = items
        return history
    }
    
}
