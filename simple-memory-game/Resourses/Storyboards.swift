//
//  Storyboards.swift
//  simple-memory-game
//
//  Created by MSI on 20.01.2021.
//

import UIKit

extension UIStoryboard {
    
    convenience init(name: String) {
        self.init(name: name, bundle: nil)
    }

    static var pexeso = UIStoryboard(name: "Pexeso")
    static var testTasksList = UIStoryboard(name: "TestTasksList")
}
