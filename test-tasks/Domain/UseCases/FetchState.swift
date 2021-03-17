//
//  FetchState.swift
//  test-tasks
//
//  Created by MSI on 18.03.2021.
//

enum FetchState<ObjectType: Equatable>: Equatable {
    /// статус - пустое состояние, объект только создан, данных  нет
    case unknown
    /// статус - данные загружаются
    case loading
    /// статус - есть данные
    case object(ObjectType)
    /// статус - данных нет
    case empty
    /// статус - при загрузке данных произошла ошибка
    case error(Error)
    
    public static func == (lhs: FetchState<ObjectType>, rhs: FetchState<ObjectType>) -> Bool {
        switch (lhs, rhs) {
        case (let .object(lhsObject), let .object(rhsObject)):
            return lhsObject == rhsObject
        case (.unknown, .unknown):
            return true
        case (.loading, .loading):
            return true
        case (.empty, .empty):
            return true
        case (let .error(lhsError), let .error(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
