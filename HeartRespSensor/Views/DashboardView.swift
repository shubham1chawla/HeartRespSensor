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
                        Text("\(heartRate, specifier: "%.2f")")
                            .font(.title)
                            .padding()
                        NavigationLink {
                            CameraView()
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
                Button {
                    print("Clicked Upload")
                } label: {
                    Image(systemName: "square.and.arrow.up")
                    Text("Upload Signs")
                }.buttonStyle(.borderedProminent)
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                HStack {
                    NavigationLink {
                        HistoryView()
                    } label: {
                        Image(systemName: "memories")
                    }
                    .sheet(isPresented: $isSymptomsSheetPresented) {
                        SymptomsView(isSymptomsSheetPresented: $isSymptomsSheetPresented)
                    }
                    Button {
                        isSymptomsSheetPresented.toggle()
                    } label: {
                        Image(systemName: "plus.app")
                    }
                    .sheet(isPresented: $isSymptomsSheetPresented) {
                        SymptomsView(isSymptomsSheetPresented: $isSymptomsSheetPresented)
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
