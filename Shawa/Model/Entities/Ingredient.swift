//
//  Ingredient.swift
//  Shawa
//
//  Created by Alex on 28.03.24.
//

import Foundation

struct Ingredient: Codable, Hashable, Identifiable{
    var id: String
    var name: String
    var cost: Double
}
