//
//  SymptomsView.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 8/31/23.
//

import SwiftUI

struct SymptomsView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]) var symptoms: FetchedResults<Symptom>
    
    @State private var symptomIndex: Int = 0
    @State private var intensity: Int = 1
    @State private var showUploadedAlert: Bool = false
    
    @EnvironmentObject var dataService: DataService
    
    private let defaults = UserDefaults.standard
    
    var body: some View {
        VStack {
            Spacer()
            Picker(selection: $symptomIndex) {
                ForEach(Array(symptoms.enumerated()), id: \.element) { index, symptom in
                    Text(symptom.name!).tag(index)
                }
            } label: {
                Image(systemName: "staroflife")
                Text("What's your symptom?")
            }
            .pickerStyle(.navigationLink)
            .padding(.vertical)
            Divider()
            Picker(selection: $intensity) {
                ForEach(Array(intensities.keys), id: \.self) { key in
                    Text("\(key) - \(intensities[key]!)").tag(key)
                }
            } label: {
                Image(systemName: "exclamationmark.circle")
                Text("How severe is the symptom?")
            }
            .pickerStyle(.navigationLink)
            .padding(.vertical)
            Spacer()
            Button {
                dataService.saveUserSymptom(symptom: symptoms[symptomIndex], intensity: intensity)
                showUploadedAlert.toggle()
            } label: {
                Image(systemName: "square.and.arrow.up")
                Text("Upload Symptom")
            }
            .buttonStyle(.borderedProminent)
            .alert("Your selected symptom has been recorded.", isPresented: $showUploadedAlert) {
                Button("Dismiss", role: .cancel) { }
            }
        }
        .navigationTitle("Symptoms")
        .padding()
    }
}
