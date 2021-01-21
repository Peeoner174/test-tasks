//
//  GameApi.swift
//  simple-memory-game
//
//  Created by MSI on 20.01.2021.
//

// Это мой самописный фреймворк для работы с сетью ( https://github.com/Peeoner174/MoyaNetworkClient-Combine )
import MoyaNetworkClient_Combine

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
