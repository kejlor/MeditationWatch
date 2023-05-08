//
//  MeditationWatchApp.swift
//  MeditationWatch Watch App
//
//  Created by Bartosz Wojtkowiak on 08/05/2023.
//

import SwiftUI

@main
struct MeditationWatch_Watch_AppApp: App {
    @StateObject private var healthKitManager = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthKitManager)
        }
    }
}
