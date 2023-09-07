//
//  HomeView.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 8/31/23.
//

import SwiftUI

struct DashboardView: View {
    
    @EnvironmentObject var dataService: DataService
    @EnvironmentObject var measurementService: MeasurementService
    
    @State private var heartRate: Double = 0
    @State private var respRate: Double = 0
    @State private var isUploadSignAlertPresented: Bool = false
    @State private var isMeasuringRespRate: Bool = false
    
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
                            isMeasuringRespRate.toggle()
                            measurementService.calculateRespRate { result in
                                switch result {
                                case .success(let respRate):
                                    self.respRate = respRate
                                    isMeasuringRespRate.toggle()
                                case .failure(let error):
                                    print(error.localizedDescription)
                                }
                            }
                        } label: {
                            if isMeasuringRespRate {
                                ProgressView()
                                    .controlSize(.large)
                                Text(" Measuring")
                            }
                            else {
                                Image(systemName: "lungs")
                                Text("\(respRate, specifier: "%.2f")")
                            }
                        }
                        .font(.largeTitle)
                        .padding()
                        .disabled(isMeasuringRespRate)
                    }
                }
                    .padding()
                Spacer()
                Button {
                    dataService.saveSensorRecord(heartRate: heartRate, respRate: respRate)
                    isUploadSignAlertPresented.toggle()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                    Text("Upload Signs")
                }.buttonStyle(.borderedProminent)
                    .alert("Your health signs has been updated.", isPresented: $isUploadSignAlertPresented) {
                        Button("Dismiss", role: .cancel) { }
                    }
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
