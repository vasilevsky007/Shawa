//
//  MenuItem.swift
//  Shawa
//
//  Created by Alex on 28.03.24.
//

import Foundation

struct MenuItem: Identifiable, Codable {
    let id: String
    var sectionIDs: Set<String>
    var name: String
    var price: Double
    var image: URL?
    let dateAdded: Date
    var popularity: Int //here smth like number of additions to cart/purchases
    var ingredientIDs: Set<String>
    var description: String
    
    init(sectionIDs: Set<String>, name: String, price: Double, image: URL? = nil, popularity: Int = 0, ingredientIDs: Set<String>, description: String) {
        self.id = UUID().uuidString
        self.sectionIDs = sectionIDs
        self.name = name
        self.price = price
        self.image = image
        self.dateAdded = .now
        self.popularity = popularity
        self.ingredientIDs = ingredientIDs
        self.description = description
    }
}
