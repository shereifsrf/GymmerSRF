//
//  GymmerView.swift
//  Gymmer SRF WatchKit Extension
//
//  Created by Mohammed Shereif on 24/10/22.
//

import SwiftUI
import WatchKit

enum Tab {
    case timer, metrics, nowPlaying
}

struct GymmerView: View {
    @State var tab: Tab = .metrics
    @State var showEndConfirmation = false
    @EnvironmentObject var wms: WorkoutManagerService
    
    var body: some View {
        TabView(selection: $tab) {
            TimerView(gym: wms.gym).tag(Tab.timer)
            MetricsView(showEndConfirmation: $showEndConfirmation).tag(Tab.metrics)
            NowPlayingView().tag(Tab.nowPlaying)
        }
        .navigationBarBackButtonHidden(tab == .metrics)
        .navigationBarHidden(tab == .metrics)
        .onChange(of: wms.running) { _ in
            displayTimer()
        }
        .alert(isPresented: $showEndConfirmation) {
            Alert(
                title: Text(""),
                message: Text("Are you sure?"),
                primaryButton: .destructive(Text("Yes"), action: stopWorkout),
                secondaryButton: .cancel()
            )
        }
    }
}

extension GymmerView {
    func stopWorkout() {
            wms.EndWorkout()
            wms.gym.Reset()
    }
    
    func displayTimer() {
        withAnimation {
            tab = .timer
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        GymmerView().environmentObject(WorkoutManagerService())
    }
}
