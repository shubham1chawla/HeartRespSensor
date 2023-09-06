//
//  HeartRespSensorApp.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 8/31/23.
//

import SwiftUI

@main
struct HeartRespSensorApp: App {
    @StateObject private var dataService = DataService()
    @StateObject private var cameraService = CameraService()
    @StateObject private var measurementService = MeasurementService()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(\.managedObjectContext, dataService.container.viewContext)
                .environmentObject(dataService)
                .environmentObject(cameraService)
                .environmentObject(measurementService)
        }
    }
}
