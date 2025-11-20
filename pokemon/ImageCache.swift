//
//  ImageCache.swift
//  pokemon
//
//  Created by Sathish  on 19/11/25.
//

import Foundation
import UIKit

actor ImageCache {
    static let shared = ImageCache()
    private var cache: [String: UIImage] = [:]

    func get(_ key: String) -> UIImage? {
        return cache[key]
    }

    func set(_ key: String, _ image: UIImage) {
        cache[key] = image
    }
}
