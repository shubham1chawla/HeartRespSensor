//
//  SymptomsView.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 8/31/23.
//

import SwiftUI

struct SymptomsView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]) var symptoms: FetchedResults<Symptom>
    
    @State private var symptomId: Int = 1
    @State private var intensity: Int = 1
    
    private let defaults = UserDefaults.standard
    
    var body: some View {
        VStack {
            Text("Symptoms Logging Page")
                .font(.title)
                .padding()
            Spacer()
            Picker(selection: $symptomId, label: Text("Symptom")) {
                ForEach(symptoms, id: \.self) { symptom in
                    Text(symptom.name!).tag(Int(symptom.id))
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
            Button("Add Symptom") {
                addUserSymptom()
            }
        }
    }
    
    func addUserSymptom() -> Void {
        let userSymptom = UserSymptom(context: moc)
        userSymptom.sessionId = defaults.string(forKey: Keys.LAST_USER_SESSION)!
        userSymptom.intensity = Int16(intensity)
        userSymptom.symptomId = Int16(symptomId)
        try? moc.save()
    }
    
}

struct SymptomsView_Previews: PreviewProvider {
    static var previews: some View {
        SymptomsView()
    }
}
