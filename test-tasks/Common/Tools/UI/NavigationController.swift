//
//  NavigationController.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import UIKit

typealias DismissClosure = (() -> ())

class NavigationController: UINavigationController {
    var closures: [String: DismissClosure] = [:]
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    
        guard let vc = rootViewController as? ViewController else { return }
        
        if let title = vc.navigationItemTitle {
            vc.title = title
        }
        if let backBarButtonItemTitle = vc.navigationItemBackBtnTitle {
            vc.navigationItem.backBarButtonItem = UIBarButtonItem(title: backBarButtonItemTitle, style: .plain, target: nil, action: nil)
        }
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

