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
    @State private var isUploadSignAlertPresented = false
    @State private var isMeasuringRespRate = false
    @State private var showRespRateTip = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                GeometryReader { geometry in
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color(UIColor.systemBackground))
                            .shadow(color: Color.primary, radius: 1)
                            .frame(width: geometry.size.width, height: geometry.size.width)
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
                                Text("Measured Heart Rate")
                            }
                            Divider()
                                .padding()
                            VStack {
                                Button {
                                    showRespRateTip.toggle()
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
                                .alert("Respiratory Rate Measurement Instructions", isPresented: $showRespRateTip) {
                                    Button("Cancel", role: .cancel) { }
                                    Button("Start Measuring", role: .none) {
                                        handleRespRateMeasurement()
                                    }
                                } message: {
                                    Text("Please lay down facing up. Place the device flat between your chest and stomach. Press the \"Start Measuring\" button and continue to take deep breaths.")
                                }
                                Text("Measured Respiratory Rate")
                            }
                        }
                    }
                    .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
                }
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
            }            .navigationTitle("Dashboard")
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
    
    private func handleRespRateMeasurement() -> Void {
        isMeasuringRespRate.toggle()
        measurementService.calculateRespRate { result in
            switch result {
            case .success(let respRate):
                self.respRate = respRate
            case .failure(let error):
                print(error.localizedDescription)
            }
            isMeasuringRespRate.toggle()
        }
    }
    
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
