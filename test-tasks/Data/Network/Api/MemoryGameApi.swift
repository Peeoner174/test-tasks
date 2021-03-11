//
//  GameApi.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

import MoyaNetworkClient_Combine
import Foundation

enum MemoryGameApi {
    case getCards
}

extension MemoryGameApi: NetworkTarget {
    var baseURL: URL {
        unimplemented()
    }
    
    var route: Route {
        unimplemented()
    }
    
    var task: Task {
        unimplemented()
    }
    
    var headers: [String : String]? {
        unimplemented()
    }
}
