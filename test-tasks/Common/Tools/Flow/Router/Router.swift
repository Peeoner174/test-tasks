//
//  Router.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import UIKit

typealias NavigationBackClosure = (() -> Void)

protocol Router: class {
    var navigationController: NavigationController { get set }
    
    init(navigationController: NavigationController)
    
    func push(_ viewController: Drawable, isAnimated: Bool, onNavigateBack: NavigationBackClosure?)
    func pop(_ isAnimated: Bool)
    func popToRoot(_ isAnimated: Bool)
    func show(_ drawable: Drawable, onNavigateBack closure: NavigationBackClosure?)
    func presentAsRoot(_ drawable: Drawable, isAnimated: Bool, setNavigationBarHidden navigationBarIsHidden: Bool)
    func presentAsStork(_ drawable: Drawable, isAnimated: Bool, onDismiss: EmptyBlock)
    func present(_ module: Drawable, animated: Bool)
    func dismiss(animated: Bool, completion: DismissClosure?)
}

class RouterImpl: NSObject, Router {
    var navigationController: NavigationController
    private var closures: [String: NavigationBackClosure] = [:]
    
    required init(navigationController: NavigationController) {
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self
    }
    
    func push(_ drawable: Drawable, isAnimated: Bool, onNavigateBack closure: NavigationBackClosure?) {
        guard let viewController = drawable.viewController else { return }

        if let closure = closure {
            closures.updateValue(closure, forKey: viewController.description)
        }
        
        navigationController.pushViewController(viewController, animated: isAnimated)
    }
    
    func show(_ drawable: Drawable, onNavigateBack closure: NavigationBackClosure?) {
        guard let viewController = drawable.viewController else { return }
        
        if let closure = closure {
            closures.updateValue(closure, forKey: viewController.description)
        }
        
        navigationController.show(viewController, sender: nil)
    }
    
    func pop(_ isAnimated: Bool) {
        navigationController.popViewController(animated: isAnimated)
    }
    
    func dismiss(animated: Bool, completion: DismissClosure?) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
    
    func popToRoot(_ isAnimated: Bool) {
        navigationController.popToRootViewController(animated: isAnimated)
    }
    
    func presentAsStork(_ drawable: Drawable, isAnimated: Bool, onDismiss closure: DismissClosure?) {
        guard let viewController = drawable.viewController else { return }
        
        if let closure = closure {
            navigationController.closures.updateValue(closure, forKey: viewController.description)
        }

        viewController.modalPresentationStyle = .popover
        navigationController.present(viewController, animated: true, completion: nil)
    }
    
    func presentAsRoot(_ drawable: Drawable, isAnimated: Bool, setNavigationBarHidden navigationBarIsHidden: Bool) {
        guard let viewController = drawable.viewController else { return }
        
        navigationController.setViewControllers([viewController], animated: isAnimated)
        navigationController.navigationBar.isHidden = false
        navigationController.setNavigationBarHidden(navigationBarIsHidden, animated: true)
    }
    
    func present(_ module: Drawable, animated: Bool) {
        guard let drawViewController = module.viewController else {
            return
        }
        
        navigationController.present(drawViewController, animated: true)
    }
    
    private func executeClosure(_ viewController: UIViewController) {
        guard let closure = closures.removeValue(forKey: viewController.description) else { return }
        closure()
    }
}

extension RouterImpl: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let previousController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(previousController) else { return }
        executeClosure(previousController)
    }
}



