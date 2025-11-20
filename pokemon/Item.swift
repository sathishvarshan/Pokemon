//
//  Item.swift
//  pokemon
//
//  Created by Sathish  on 19/11/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
