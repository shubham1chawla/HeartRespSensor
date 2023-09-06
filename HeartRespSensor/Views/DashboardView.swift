//
//  HomeView.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 8/31/23.
//

import SwiftUI

struct DashboardView: View {
    @State private var heartRate: Double = 0
    @State private var respRate: Double = 0
    @State private var isSymptomsSheetPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                VStack {
                    VStack {
                        NavigationLink {
                            CameraView(heartRate: $heartRate)
                        } label: {
                            Image(systemName: "heart")
                            Text("\(heartRate, specifier: "%.2f")")
                        }
                        .font(.largeTitle)
                        .padding()
                    }
                    Divider()
                        .padding()
                    VStack {
                        Button {
                            print("Clicked RR")
                        } label: {
                            Image(systemName: "lungs")
                            Text("\(respRate, specifier: "%.2f")")
                        }
                        .font(.largeTitle)
                        .padding()
                    }
                }
                    .padding()
                Spacer()
                Button {
                    print("Clicked Upload")
                } label: {
                    Image(systemName: "square.and.arrow.up")
                    Text("Upload Signs")
                }.buttonStyle(.borderedProminent)
            }
            .navigationTitle("Dashboard")
            .toolbar {
                HStack {
                    NavigationLink {
                        HistoryView()
                    } label: {
                        Image(systemName: "memories")
                    }
                    NavigationLink {
                        SymptomsView()
                    } label: {
                        Image(systemName: "plus.app")
                    }
                }
            }
            .padding()
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
