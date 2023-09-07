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
                    DisclosureGroup("\(userSession.timestamp!.formatted())") {
                        getDisclosureGroupContent(userSession)
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
        var propId = 0
        
        // Flattening the sensor record
        if let sensorRecord = userSession.sensorRecord {
            if sensorRecord.heartRate > 0 {
                props.append(HistoryProperty(id: propId, name: "Heart Rate", value: String(format: "%.2f", sensorRecord.heartRate)))
                propId += 1
            }
            if sensorRecord.respRate > 0 {
                props.append(HistoryProperty(id: propId, name: "Respiratory Rate", value: String(format: "%.2f", sensorRecord.respRate)))
                propId += 1
            }
        }
        
        // Flattening the user symptoms
        if let userSymptoms = userSession.userSymptoms {
            for element in userSymptoms {
                let userSymptom = element as! UserSymptom
                props.append(HistoryProperty(id: propId, name: userSymptom.symptom!.name!, value: String(userSymptom.intensity)))
                propId += 1
            }
        }
        
        return props
    }
    
}
