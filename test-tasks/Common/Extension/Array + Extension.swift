//
//  Array + Extension.swift
//  test-tasks
//
//  Created by MSI on 21.01.2021.
//

import Foundation

extension Array {
    subscript(guarded idx: Int) -> Element? {
        guard (startIndex..<endIndex).contains(idx) else {
            return nil
        }
        return self[idx]
    }
}

extension Array {
    mutating func removeFirst(where block: (Element) -> Bool) {
        guard let index = self.enumerated().first(where: { block($0.element) } )?.offset else { return }
        self.remove(at: index)
    }
}

