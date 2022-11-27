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
    private let secondNotifyAfter = TimeInterval(3)
    
    func RequestPermission() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: options) { success, error in
            if let error = error {
                print("Error", error)
            } else {
                // for success
            }
        }
    }
    
    func ClearSchedule(g: String = "") {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    // schedule the notification
    func ScheduleNotification(interval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Times Up"
        content.subtitle = "Click here to stop"
        content.sound = .default
        content.badge = 1
        
        // time
        let trigger1 = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let trigger2 = UNTimeIntervalNotificationTrigger(timeInterval: interval + secondNotifyAfter, repeats: false)
        
        //calender
        let request1 = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger1)
        let request2 = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger2)
        
        ClearSchedule()
        UNUserNotificationCenter.current().add(request1)
        UNUserNotificationCenter.current().add(request2)
    }
}
