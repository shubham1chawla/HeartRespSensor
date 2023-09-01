//
//  HomeView.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 8/31/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                HStack {
                    VStack {
                        Text("69.69")
                            .font(.largeTitle)
                            .padding()
                        Button("Heart Rate") {
                            print("Clicked HR")
                        }
                    }
                    VStack {
                        Text("420")
                            .font(.largeTitle)
                            .padding()
                        Button("Respiratory Rate") {
                            print("Clicked RR")
                        }
                    }
                }
                .padding()
                Spacer()
                HStack {
                    NavigationLink {
                        SymptomsView()
                    } label: {
                        Text("Symptoms")
                    }
                    .buttonStyle(.bordered)
                    Button("Upload Signs") {
                        
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
