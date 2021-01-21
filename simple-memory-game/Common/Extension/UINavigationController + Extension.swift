//
//  UINavigationController + Extension.swift
//  simple-memory-game
//
//  Created by MSI on 20.01.2021.
//

import UIKit

extension UINavigationController {
    func setStatusBarBackground(color: UIColor) {
        statusBarUIView?.backgroundColor = color
    }
    
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 3848245

            let keyWindow = UIApplication.shared.connectedScenes
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows.first

            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
                let statusBarView = UIView(frame: height)
                statusBarView.tag = tag
                statusBarView.layer.zPosition = 999999

                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }

        } else {
            return UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        }
    }
}
