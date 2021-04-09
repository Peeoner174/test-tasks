//
//  HasDataModel.swift
//  test-tasks
//
//  Created by MSI on 08.04.2021.
//

import UIKit

protocol HasDataModel: UIView {
    associatedtype DataModel
    
    /// Contain information for display
    var dataModel: DataModel { get set }
}

