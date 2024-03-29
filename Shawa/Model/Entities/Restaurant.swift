//
//  Restaurant.swift
//  Shawa
//
//  Created by Alex on 28.03.24.
//

import Foundation

struct Restaurant: Identifiable {
    var id: String
    var name: String
    var menu: [MenuItem]
    var ingredients: [Ingredient]
    var sections: [MenuSection]
}

extension Restaurant {
    enum CodingKeys: String, CodingKey {
        case id, name, menu, ingredients, sections
    }
}
