//
//  SymptomsView.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 8/31/23.
//

import SwiftUI

struct SymptomsView: View {
    @FetchRequest(sortDescriptors: []) var symptoms: FetchedResults<Symptom>
    
    @State private var selected: Int = 1
    @State private var intensity: Int = 0
    
    var body: some View {
        VStack {
            Text("Symptoms Logging Page")
                .font(.title)
                .padding()
            Spacer()
            Picker(selection: $selected, label: Text("Symptom")) {
                ForEach(symptoms, id: \.self) { symptom in
                    Text(symptom.name ?? "Unknown").tag(symptom.id)
                }
            }
            .pickerStyle(.wheel)
            .padding()
            Picker(selection: $intensity, label: Text("Intensity")) {
                ForEach(0...5, id: \.self) {
                    Text("\($0)").tag($0)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            Spacer()
            Button("Add Symptom") {
                print("\(selected) - \(intensity)")
            }
        }
    }
}

struct SymptomsView_Previews: PreviewProvider {
    static var previews: some View {
        SymptomsView()
    }
}
