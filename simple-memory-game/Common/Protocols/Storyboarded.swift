//
//  Storyboarded.swift
//  simple-memory-game
//
//  Created by MSI on 20.01.2021.
//

import UIKit

protocol Storyboarded { }

extension Storyboarded where Self: UIViewController {

    static func instantiate(fromStoryboard storyboard: UIStoryboard) -> Self {
        return storyboard.instantiateViewController(withIdentifier: self.reuseIdentifier) as! Self
    }
}

extension UIViewController: Storyboarded {}
