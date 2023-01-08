//
//  AppDelegate.swift
//  Gymmer SRF Watch App
//
//  Created by Mohammed Shereif on 27/11/22.
//

import Foundation
import UserNotifications
import SwiftUI

class AppDelgate: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {        
        LocalNotificationService.shared.ClearSchedule()
        completionHandler()
    }
    
    func Register() {
        UNUserNotificationCenter.current().delegate = self
    }
}
