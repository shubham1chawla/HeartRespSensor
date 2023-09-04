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
    
    @Binding var isSymptomsSheetPresented: Bool
    @EnvironmentObject var dataService: DataService
    
    private let defaults = UserDefaults.standard
    
    var body: some View {
        VStack {
            Text("Symptoms Logging Page")
                .font(.title)
                .padding()
            Spacer()
            Picker(selection: $symptomIndex, label: Text("Symptom")) {
                ForEach(Array(symptoms.enumerated()), id: \.element) { index, symptom in
                    Text(symptom.name!).tag(index)
                }
            }
            .pickerStyle(.wheel)
            .padding()
            Picker(selection: $intensity, label: Text("Intensity")) {
                ForEach(1...5, id: \.self) {
                    Text("\($0)").tag($0)
                }
            }
            .pickerStyle(.segmented)
            .padding()
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
                Button("Dismiss", role: .cancel) {
                    isSymptomsSheetPresented.toggle()
                }
            }
        }
    }
}
