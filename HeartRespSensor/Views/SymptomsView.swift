//
//  SymptomsView.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 8/31/23.
//

import SwiftUI

struct SymptomsView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]) var symptoms: FetchedResults<Symptom>
    @EnvironmentObject var dataService: DataService
    
    @State private var symptomIndex: Int = 0
    @State private var intensity: Int = 1
    @State private var showUploadedAlert: Bool = false
    
    var body: some View {
        Form {
            Section("Tell us about your symptoms") {
                Picker(selection: $symptomIndex) {
                    ForEach(Array(symptoms.enumerated()), id: \.element) { index, symptom in
                        Text(symptom.name!).tag(index)
                    }
                } label: {
                    Image(systemName: "staroflife")
                    Text("Symptom")
                }
                .pickerStyle(.navigationLink)
                Picker(selection: $intensity) {
                    ForEach(Array(dataService.intensities.keys).sorted(), id: \.self) { key in
                        Text("\(key) - \(dataService.intensities[key]!)").tag(key)
                    }
                } label: {
                    Image(systemName: "exclamationmark.circle")
                    Text("Severity")
                }
                .pickerStyle(.navigationLink)
            }
            Button {
                dataService.saveUserSymptom(symptom: symptoms[symptomIndex], intensity: intensity)
                showUploadedAlert.toggle()
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.down")
                    Text("Save Symptom")
                }
            }
            .frame(maxWidth: .infinity)
            .alert("Your selected symptom has been recorded.", isPresented: $showUploadedAlert) {
                Button("Dismiss", role: .cancel) { }
            }
        }
        .navigationTitle("Symptoms")
    }

}
