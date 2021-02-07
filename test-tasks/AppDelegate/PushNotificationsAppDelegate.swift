//
//  PushNotificationsAppDelegate.swift
//  test-tasks
//
//  Created by MSI on 07.02.2021.
//

import UIKit
import UserNotifications

class PushNotificationsAppDelegate: AppDelegateType {
    var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
                
            }
    }
}
