//
//  Drawable.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import UIKit

protocol Drawable {
    var viewController: ViewController? { get }
}

extension ViewController: Drawable {
    var viewController: ViewController? { return self }
}

