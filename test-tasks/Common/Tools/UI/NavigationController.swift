//
//  NavigationController.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import UIKit

typealias DismissClosure = (() -> Void)

class NavigationController: UINavigationController {
    var closures: [String: DismissClosure] = [:]
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(rootViewController: ViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        
        guard let previousController = transitionCoordinator?.viewController(forKey: .from) else { return }
        executeClosure(previousController)
    }
    
    private func executeClosure(_ viewController: UIViewController) {
         guard let closure = closures.removeValue(forKey: viewController.description) else { return }
         closure()
     }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

