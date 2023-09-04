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
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, dataService.container.viewContext)
                .environmentObject(dataService)
        }
    }
}
