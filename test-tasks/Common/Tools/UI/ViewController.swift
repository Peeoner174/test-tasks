//
//  ViewController.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    lazy var didDisappear = _didDisappear.eraseToAnyPublisher()
    private let _didDisappear = Combine.PassthroughSubject<Void, Never>()
    
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self._didDisappear.send()
        self._didDisappear.send(completion: .finished)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
