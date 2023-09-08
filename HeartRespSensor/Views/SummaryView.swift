//
//  SummaryView.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 9/8/23.
//

import SwiftUI

struct SummaryView: View {
    
    let userSession: UserSession
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    VStack {
                        HStack {
                            Image(systemName: "heart")
                            Text("\(getHeartRate(), specifier: "%.2f")")
                        }
                        .font(.largeTitle)
                        .padding()
                        Text("Measured Heart Rate")
                    }
                    .padding()
                    Divider()
                    VStack {
                        HStack {
                            Image(systemName: "lungs")
                            Text("\(getRespRate(), specifier: "%.2f")")
                        }
                        .font(.largeTitle)
                        .padding()
                        Text("Measured Respiratory Rate")
                    }
                    .padding()
                    let userSymptoms = getUserSymptoms()
                    Divider()
                    ForEach(userSymptoms, id: \.self) { userSymptom in
                        HStack {
                            Image(systemName: "staroflife")
                            Text(userSymptom.symptom!.name!)
                            Spacer()
                            Text("\(intensities[Int(userSymptom.intensity)]!) (\(userSymptom.intensity))")
                        }
                        .padding()
                        Divider()
                    }
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                        Text(userSession.timestamp!.formatted(date: .abbreviated, time: .shortened))
                    }
                    .padding()
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: UIConstants.CORNER_RADIUS, style: .continuous)
                        .fill(UIConstants.BACKGROUND_COLOR)
                        .padding()
                }
                .overlay {
                    RoundedRectangle(cornerRadius: UIConstants.CORNER_RADIUS)
                        .stroke(UIConstants.STROKE_COLOR, lineWidth: UIConstants.STROKE_LINE_WIDTH)
                        .padding()
                }
            }
        }
        .navigationTitle("Summary")
    }
    
    private func getHeartRate() -> Double {
        return userSession.sensorRecord?.heartRate ?? 0
    }
    
    private func getRespRate() -> Double {
        return userSession.sensorRecord?.respRate ?? 0
    }
    
    private func getUserSymptoms() -> [UserSymptom] {
        if let userSymptoms = userSession.userSymptoms {
            return userSymptoms.allObjects as! [UserSymptom]
        }
        return []
    }

}
