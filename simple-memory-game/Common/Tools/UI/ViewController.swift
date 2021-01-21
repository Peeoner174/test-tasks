//
//  ViewController.swift
//  simple-memory-game
//
//  Created by MSI on 20.01.2021.
//

import UIKit

class ViewController: UIViewController {
    
    var navigationItemTitle: String? {
        didSet {
            self.title = self.navigationItemTitle
        }
    }
    var navigationItemBackBtnTitle: String? {
        didSet {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: self.navigationItemBackBtnTitle, style: .plain, target: nil, action: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForegroundNotification(notification:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    @objc func willEnterForegroundNotification(notification: NSNotification) { }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
