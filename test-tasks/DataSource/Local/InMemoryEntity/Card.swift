//
//  CardModel.swift
//  test-tasks
//
//  Created by MSI on 19.01.2021.
//

import UIKit

struct Card: Codable {
    let refKey: Int
    var isFlipped: Bool
    var image: String?
    var isClickable : Bool
    
    init(refKey: Int, isFlipped: Bool = false, image: String? = nil, isClickable: Bool = true) {
        self.refKey = refKey
        self.isFlipped = isFlipped
        self.image = image
        self.isClickable = isClickable
    }
    
    enum CodingKeys: CodingKey {
        case isFlipped, image, isClickable, refKey
    }
}
