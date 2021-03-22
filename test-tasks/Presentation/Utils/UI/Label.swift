//
//  Label.swift
//  test-tasks
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
    
    func setFormattedText(_ text: String?) {
        self.text = text == nil && format.isEmpty ? text : String(format: format, text!)
    }
    
    func setFormattedText(_ text: String?, format: String) {
        self.format = format
        self.text = text == nil && format.isEmpty ? text : String(format: format, text!)
    }
    
    func getFormattedText() -> String? {
        guard let text = self.text else {
            return nil
        }
        return String(format: self.format, text)
    }
    
    func getFormattedText(format: String) -> String? {
        guard let text = self.text else {
            return nil
        }
        return String(format: format, text)
    }
}
