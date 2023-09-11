//
//  SummaryView.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 9/8/23.
//

import SwiftUI

struct SummaryView: View {
    
    @EnvironmentObject var dataService: DataService
    
    let userSession: UserSession
    @State private var image: Image?
    
    var summary: some View {
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
                        Text("\(dataService.intensities[Int(userSymptom.intensity)]!) (\(userSymptom.intensity))")
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
    
    var body: some View {
        ScrollView {
            summary
                .onAppear {
                    if image == nil {
                        image = Image(uiImage: summary.snapshot())
                    }
                }
            if image != nil {
                ShareLink(item: image!, preview: SharePreview("Health Summary", image: image!)) {
                    Label("Share Summary", systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.borderedProminent)
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
