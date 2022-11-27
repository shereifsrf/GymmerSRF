//
//  Gymmer_SRFApp.swift
//  Gymmer SRF Watch App
//
//  Created by Mohammed Shereif on 18/11/22.
//

import SwiftUI

@main
struct Gymmer_SRF_Watch_AppApp: App {
    @StateObject var workoutManager = WorkoutManagerService()
    let appDelegate = AppDelgate()
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .onAppear() {
                workoutManager.RequestAuthorization()
                appDelegate.Register()
            }
            .environmentObject(workoutManager)
        }
    }
}
