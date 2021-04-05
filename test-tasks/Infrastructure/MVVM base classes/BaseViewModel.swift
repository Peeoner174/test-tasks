//
//  ViewModel.swift
//  test-tasks
//
//  Created by Pavel Kochenda on 05.04.2021.
//

import Combine

/// Base View Model to remove boilerplate for custom View Models
class BaseViewModel {
    
    /// Dispose bag of the View Model
    var bindings = Set<AnyCancellable>()
    
    /// Called when view controller called `viewDidLoad`
    let viewDidLoad: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    /// Called when view controller called `viewWillAppear`
    let viewWillAppear: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    /// Called when view controller called `viewDidAppear`
    let viewDidAppear: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    /// Called when view controller called `viewWillDisappear`
    let viewWillDisappear: PassthroughSubject<Void, Never> = PassthroughSubject()
}


