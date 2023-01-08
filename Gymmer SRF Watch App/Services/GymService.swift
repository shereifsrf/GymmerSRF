//
//  Gym.swift
//  Gymmer SRF WatchKit Extension
//
//  Created by Mohammed Shereif on 23/10/22.
//

import Foundation
import WatchKit

enum ControlStatus {
    case started, paused, stopped, ended
}

class Gym: ObservableObject {
    
    // MARK: published
    @Published var Status: ControlStatus
    
    // MARK: non-published
    var mainConfig: ButtonListModel
    var endsAt: Date?
    var duration: TimeInterval {
        didSet {
            guard duration > 0 else {
                return
            }
        }
    }
    
    init() {
        Status = .ended
        mainConfig = ButtonService.shared.config
        duration = TimeInterval(mainConfig.mainButton.value)
    }
    
    
    // MARK: Public functions
    func Execute(type: ButtonTypeEnum) async {
        switch self.Status {
        case .ended, .stopped:
            await start(type)
        case .started:
            changeFromRunning(type)
        case .paused:
            changeFromPause(type)
        }
    }
    
    func GetRemainingSeconds() -> TimeInterval {
        guard self.Status == .started else {
            if self.Status == .ended || self.Status == .stopped {
                duration = TimeInterval(mainConfig.mainButton.value)
            }
            return duration
        }
        
        duration = self.endsAt!.timeIntervalSinceNow
    
        if duration <= 0 {
            WKInterfaceDevice.current().play(.notification)
        }
        
        return duration
    }
    
    func Reset() {
        self.duration = TimeInterval(mainConfig.mainButton.value)
        self.Status = .ended
        mainConfig.HideIcon()
    }
    
    
    // MARK: private functions
    func start(_ type: ButtonTypeEnum) async {
        let duration = mainConfig.GetDuration(buttonType: type)
        guard duration > 0 else { return }
        
        // add local notification
        await LocalNotificationService.shared.ScheduleNotification(interval: self.duration)
        
        self.duration = TimeInterval(duration)
        
        mainConfig.ShowIcon()
        play()
    }
    
    func changeFromRunning(_ type: ButtonTypeEnum) {
        // stop or end || remaining is negative
        if type != ButtonTypeEnum.main || self.duration <= 0 {
            stop(type)
            return
        }
        
        // pause if remaining is positive
        // set the remaining duration
        self.duration = self.endsAt?.timeIntervalSince(.now) ?? 0
        mainConfig.MainPlayIcon()
        self.Status = .paused
    }
    
    func changeFromPause(_ type: ButtonTypeEnum) {
        // stop or end the session if its not main button
        if type != ButtonTypeEnum.main {
            stop(type)
            return
        }
        
        // continue if main button
        play()
    }
    
    func stop(_ type: ButtonTypeEnum) {
        mainConfig.HideIcon()
        switch type {
        case .left, .main:
            self.Status = .stopped
        case .right:
            self.Status = .ended
        }
        self.duration = TimeInterval(mainConfig.mainButton.value)
        LocalNotificationService.shared.ClearSchedule()
    }
    
    func play() {
        guard self.Status != .started else { return }
        
        // starting
        if self.endsAt == nil {
            self.endsAt = Calendar.current.date(byAdding: .second, value: Int(self.duration), to: self.endsAt ?? Date())
        }
        // play after pause
        else {
            self.endsAt = Date().addingTimeInterval(self.duration)
        }
        
        // start only after defining endsAt value
        // otherwise there will be concurrency issues
        mainConfig.MainPauseIcon()
        self.Status = .started
    }
}
