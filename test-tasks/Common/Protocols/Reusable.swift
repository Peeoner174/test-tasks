//
//  Reusable.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import UIKit

// MARK: - Auto creation reuseIdentifier
protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UIView: Reusable { }
extension UIViewController: Reusable { }
