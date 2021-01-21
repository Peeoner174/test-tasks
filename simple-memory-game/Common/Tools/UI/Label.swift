//
//  Label.swift
//  simple-memory-game
//
//  Created by MSI on 20.01.2021.
//

import UIKit

class Label: UILabel {
    @IBInspectable var format: String = ""
    
    @IBInspectable var fontStyle: String = "regular" {
        didSet {
            font = .font(withStyle: FontStyle(rawValue: fontStyle.lowercased()) ?? .regular, size: fontSize)
        }
    }
    
    @IBInspectable var fontSize: CGFloat = 12 {
        didSet {
            font = font.withSize(self.fontSize)
        }
    }
    
    var onTextUpdateBlock: ((String?) -> Void)? = nil
    
    override var text: String? {
        didSet {
            onTextUpdateBlock?(self.text)
        }
    }
    
    public func setFormattedText(_ text: String?) {
        self.text = text == nil && format.isEmpty ? text : String(format: format, text!)
    }
    
    public func setFormattedText(_ text: String?, format: String) {
        self.format = format
        self.text = text == nil && format.isEmpty ? text : String(format: format, text!)
    }
}
