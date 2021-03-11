//
//  Storyboarded.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import UIKit

protocol Storyboarded { }

extension Storyboarded where Self: UIViewController {    
    static func instantiate(fromStoryboard storyboard: UIStoryboard, creator: ((NSCoder) -> Self?)?) -> Self {
        storyboard.instantiateViewController(identifier: self.reuseIdentifier, creator: creator)
    }
}

extension UIViewController: Storyboarded {}
