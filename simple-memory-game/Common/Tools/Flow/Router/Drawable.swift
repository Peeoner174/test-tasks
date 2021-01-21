//
//  Drawable.swift
//  simple-memory-game
//
//  Created by MSI on 20.01.2021.
//

import UIKit

protocol Drawable {
    var viewController: UIViewController? { get }
}

extension UIViewController: Drawable {
    var viewController: UIViewController? { return self }
}

