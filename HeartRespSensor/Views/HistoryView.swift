//
//  HistoryView.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 9/4/23.
//

import SwiftUI

struct HistoryView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "timestamp", ascending: false)]) var userSessions: FetchedResults<UserSession>
    @EnvironmentObject var dataService: DataService
    
    struct HistoryProperty: Identifiable {
        let id: Int
        var name: String
        var value: String
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(userSessions, id: \.self) { userSession in
                    if dataService.doesUserSessionContainsProperties(userSession) {
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
    
    private func getHistoryProperties(_ userSession: UserSession) -> [HistoryProperty] {
        var props: [HistoryProperty] = []
        
        // Flattening the sensor record
        if let sensorRecord = userSession.sensorRecord {
            if sensorRecord.heartRate > 0 {
                props.append(HistoryProperty(id: 1, name: "Heart Rate", value: String(format: "%.2f", sensorRecord.heartRate)))
            }
            if sensorRecord.respRate > 0 {
                props.append(HistoryProperty(id: 2, name: "Respiratory Rate", value: String(format: "%.2f", sensorRecord.respRate)))
            }
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
