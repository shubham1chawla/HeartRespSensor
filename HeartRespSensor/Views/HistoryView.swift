//
//  HistoryView.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 9/4/23.
//

import SwiftUI

struct HistoryView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "timestamp", ascending: false)]) var userSessions: FetchedResults<UserSession>
    
    struct HistoryProperty: Identifiable {
        let id: Int
        var name: String
        var value: String
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(userSessions, id: \.self) { userSession in
                    if shouldDisplayUserSession(userSession) {
                        DisclosureGroup("\(userSession.timestamp!.formatted())") {
                            getDisclosureGroupContent(userSession)
                        }
                    }
                }
            }
        }
        .navigationTitle("History")
        .padding()
    }
    
    private func getDisclosureGroupContent(_ userSession: UserSession) -> some View {
        return VStack {
            ForEach(getHistoryProperties(userSession), id: \.id) { property in
                HStack {
                    Text(property.name)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(property.value)
                }
            }
        }
    }

    private func shouldDisplayUserSession(_ userSession: UserSession) -> Bool {
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
    
    private func getHistoryProperties(_ userSession: UserSession) -> [HistoryProperty] {
        var props: [HistoryProperty] = []
        
        // Flattening the sensor record
        if let sensorRecord = userSession.sensorRecord {
            props.append(HistoryProperty(id: 1, name: "Heart Rate", value: String(format: "%.2f", sensorRecord.heartRate)))
            props.append(HistoryProperty(id: 2, name: "Respiratory Rate", value: String(format: "%.2f", sensorRecord.respRate)))
        }
        
        // Flattening the user symptoms
        if let userSymptoms = userSession.userSymptoms {
            for element in userSymptoms {
                let userSymptom = element as! UserSymptom
                props.append(HistoryProperty(id: Int(userSymptom.symptom!.id), name: userSymptom.symptom!.name!, value: String(userSymptom.intensity)))
            }
        }
        
        return props
    }
    
}
