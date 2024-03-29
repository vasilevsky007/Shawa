//
//  MenuItem.swift
//  Shawa
//
//  Created by Alex on 28.03.24.
//

import Foundation

struct MenuItem: Identifiable, Codable {
    var id: String
    var sectionIDs: Set<String>
    var name: String
    var price: Double
    var image: URL?
    var dateAdded: Date
    var popularity: Int //here smth like number of additions to cart/purchases
    var ingredientIDs: Set<String>
    var description: String
}
