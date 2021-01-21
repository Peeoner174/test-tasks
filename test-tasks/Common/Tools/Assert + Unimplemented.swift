//
//  Assert + Unimplemented.swift
//  test-tasks
//
//  Created by MSI on 19.01.2021.
//

import Foundation

func unimplemented(_ fn: String = #function, file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("❗️ \(fn) is not yet full implemented", file: file, line: line)
}
