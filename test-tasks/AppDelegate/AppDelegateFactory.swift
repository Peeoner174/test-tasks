//
//  AppDelegateFactory.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import UIKit

enum AppDelegateFactory {
    static func makeDefault(_ window: UIWindow?) -> AppDelegateType {
        return CompositeAppDelegate(appDelegates: [])
    }
}
