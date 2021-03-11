//
//  PushNotificationsAppDelegate.swift
//  test-tasks
//
//  Created by MSI on 07.02.2021.
//

import UIKit
import UserNotifications

fileprivate enum Identifiers {
  static let viewAction = "VIEW_IDENTIFIER"
  static let newsCategory = "NEWS_CATEGORY"
}

class PushNotificationsAppDelegate: AppDelegateType {
    var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications()
        
        if let notification = launchOptions?[.remoteNotification] as? [String : Any] {
            if let aps = notification["aps"] as? [String : Any] {
                logger.info("App did launched from notification with aps: \n\(aps)")
            } else {
                logger.error("Attempt cast notification data failed")
            }
        }
            
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let aps = userInfo["aps"] as? [String : Any] else {
            logger.error("Attempt cast notification data failed")
            completionHandler(.failed)
            return
        }
        if aps["content-available"] as? Int == 1 {
            logger.info("App did receive silent notification with aps: \n\(aps)")
            
        } else {
            logger.info("App did receive notification with aps: \n\(aps)")
        }
        completionHandler(.noData)
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, _ in
                logger.info("Permission granted: \(granted)")
                guard granted else { return }
                
                let viewAction = UNNotificationAction(
                    identifier: Identifiers.viewAction,
                    title: "View",
                    options: [.foreground]
                )
                
                let newsCategory = UNNotificationCategory(
                    identifier: Identifiers.newsCategory,
                    actions: [viewAction],
                    intentIdentifiers: [],
                    options: []
                )
                
                UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
                
                self?.getNotificationSettings()
            }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            logger.info("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenPairs = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenPairs.joined()
        logger.info("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        logger.error("Failed to register: \(error)")
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension PushNotificationsAppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        guard let aps = notification.request.content.userInfo["aps"] as? [String : Any] else {
            logger.error("Attempt cast notification data failed")
            completionHandler([])
            return
        }
        logger.info(
            "Did receive notification in App-foreground with aps: \n\(aps)"
        )
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let aps = response.notification.request.content.userInfo["aps"] else {
            logger.error("Attempt cast notification data failed")
            completionHandler()
            return
        }
    
        if response.actionIdentifier == Identifiers.viewAction {
            logger.info("Action with id: \(Identifiers.viewAction) was tapped on notification with aps: \n\(aps)")
        }
        completionHandler()
    }
}


