//
//  FetchState.swift
//  test-tasks
//
//  Created by MSI on 18.03.2021.
//

enum FetchState<ObjectType: Equatable>: Equatable {
    /// Пустое состояние, объект только создан, данных  нет
    case unknown
    /// Данные загружаются
    case loading
    /// Есть данные
    case object(ObjectType)
    /// Данных нет
    case empty
    /// При загрузке данных произошла ошибка
    case error(Error)
    /// Цепочка загрузки данных успешно завершена. 
    case complete
    
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
