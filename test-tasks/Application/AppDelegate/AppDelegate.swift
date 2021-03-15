//
//  AppDelegate.swift
//  test-tasks
//
//  Created by MSI on 19.01.2021.
//

import UIKit
import Combine

@main
class AppDelegate: UIResponder, UIApplicationDelegate, NetworkStatusSupplier {
    private var bindings = Set<AnyCancellable>()

    lazy var appDelegate = AppDelegateFactory.makeDefault(self.window)
    var window: UIWindow?
    private var appCoordinator: AppCoordinator!
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        _ = appDelegate.application?(application, willFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        
        logger.start()
        _ = appDelegate.application?(application, didFinishLaunchingWithOptions: launchOptions)
        
        self.appCoordinator = AppCoordinator(window: window!)
        self.appCoordinator.start().sink().store(in: &bindings)
        
        ReachabilityManager.shared.addListener(self)
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        appDelegate.applicationWillEnterForeground?(application)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        appDelegate.applicationDidEnterBackground?(application)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        appDelegate.applicationDidBecomeActive?(application)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        appDelegate.applicationWillResignActive?(application)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        appDelegate.applicationWillTerminate?(application)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        appDelegate.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        appDelegate.application?(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        appDelegate.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
}

