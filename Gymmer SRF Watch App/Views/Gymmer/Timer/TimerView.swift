//
//  TimerView.swift
//  Gymmer SRF WatchKit Extension
//
//  Created by Mohammed Shereif on 15/10/22.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var gym: Gym
    
    var body: some View {
        VStack {
            TimelineView(.periodic(from: Date(), by: 1)) { _ in
                CountDownTimeView(remainingSeconds: gym.GetRemainingSeconds())
            }
            
            ElapsedTimeView(font: .small)
            
            Spacer()
            
            ButtonsView(config: gym.mainConfig,
                        mainButtonAction: mainButtonAction,
                        leftButtonAction: leftButtonAction,
                        rightButtonAction: rightButtonAction)
        }
        .padding(.bottom, 5)
        .ignoresSafeArea(edges: .bottom)
    }
}

extension TimerView {
    func mainButtonAction() {
        Task {
            await gym.Execute(type: .main)
        }
    }
    
    func leftButtonAction() {
        Task {
            await gym.Execute(type: .left)
        }
    }
    
    func rightButtonAction() {
        Task {
            await gym.Execute(type: .right)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let gym = Gym()
        gym.mainConfig.HideIcon()
        
        return TimerView(gym: Gym())
    }
}

struct MainView_Pause: PreviewProvider {
    static var previews: some View {
        let gym = Gym()
        gym.mainConfig.ShowIcon()
        
        return TimerView(gym: Gym())
    }
}
