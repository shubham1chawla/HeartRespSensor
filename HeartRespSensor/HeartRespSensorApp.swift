//
//  HeartRespSensorApp.swift
//  HeartRespSensor
//
//  Created by Shubham Chawla on 8/31/23.
//

import SwiftUI

@main
struct HeartRespSensorApp: App {
    private let dataService = DataService()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(\.managedObjectContext, dataService.container.viewContext)
                .environmentObject(dataService)
                .environmentObject(CameraService())
                .environmentObject(MeasurementService())
                .environmentObject(PhotoLibraryService())
        }
    }
}
