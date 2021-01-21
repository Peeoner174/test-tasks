//
//  Fonts.swift
//  test-tasks
//
//  Created by MSI on 20.01.2021.
//

// Обычно во всем приложении используется один шрифт, который импортируется в формате .ttf
// Эта обертка удобна именно в таких случаях, но для тестового задания я взял системный шрифт

import UIKit

enum FontStyle: String {
    case bold
    case regular
    case medium
    case light
//    case italic
}

extension UIFont {
    
    static func font(withStyle style: FontStyle, size: CGFloat) -> UIFont {
        switch style {
        case .bold: return .systemFont(ofSize: size, weight: .bold)
        case .regular: return .systemFont(ofSize: size, weight: .regular)
        case .medium: return .systemFont(ofSize: size, weight: .medium)
        case .light: return .systemFont(ofSize: size, weight: .light)
//        case .italic: return .systemFont(ofSize: size, weight: .)
        }
    }
}
