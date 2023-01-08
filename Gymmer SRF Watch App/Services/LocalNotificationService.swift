//
//  LocalNotificationService.swift
//  Gymmer SRF Watch App
//
//  Created by Mohammed Shereif on 22/11/22.
//

import Foundation
import UserNotifications


class LocalNotificationService {
    static let shared = LocalNotificationService()
    private init(){}
    
    private var scheduled = false
    
    func requestPermission() async throws -> Bool {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        let center = UNUserNotificationCenter.current()
        
        return try await center.requestAuthorization(options: options)
    }
    
    func ClearSchedule() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    // schedule the notification
    func ScheduleNotification(interval: TimeInterval) async {
        do {
            let granted = try await requestPermission()
            print("granted: ", granted)
        } catch {
            print(error)
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Times Up"
        content.subtitle = "Click here to stop"
        content.sound = .default
        content.badge = 1
        
        // time
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        
        //calender
        ClearSchedule()
        scheduleAlarm(content: content, trigger: trigger)
        scheduleAlarmsAfter(content: content, interval: interval)
    }
    
    func scheduleAlarm(content: UNMutableNotificationContent, trigger: UNTimeIntervalNotificationTrigger) {
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleAlarmsAfter(content: UNMutableNotificationContent, interval: TimeInterval) {
        for i in 1...Constants.shared.noOfAlarmsAfter {
            let extraSeconds = TimeInterval(i) * Constants.shared.secondNotifyAfter
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval + extraSeconds, repeats: false)
            scheduleAlarm(content: content, trigger: trigger)
        }
    }
}
