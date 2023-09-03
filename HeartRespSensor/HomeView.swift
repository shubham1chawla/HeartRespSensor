//
//  HomeView.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 8/31/23.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) var moc
    
    @State private var heartRate: Double = 0
    @State private var respRate: Double = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                VStack {
                    VStack {
                        Text("\(heartRate, specifier: "%.2f")")
                            .font(.largeTitle)
                            .padding()
                        Button {
                            print("Clicked HR")
                        } label: {
                            Image(systemName: "heart")
                            Text("Measure Heart Rate")
                        }
                    }
                    Divider()
                        .padding()
                    VStack {
                        Text("\(respRate, specifier: "%.2f")")
                            .font(.largeTitle)
                            .padding()
                        Button {
                            print("Clicked RR")
                        } label: {
                            Image(systemName: "lungs")
                            Text("Measure Respiratory Rate")
                        }
                    }
                }
                    .padding()
                Spacer()
                HStack {
                    NavigationLink {
                        SymptomsView()
                    } label: {
                        Image(systemName: "plus.app")
                        Text("Add Symptoms")
                    }
                    .buttonStyle(.bordered)
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                        Text("Upload Signs")
                    }.buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
