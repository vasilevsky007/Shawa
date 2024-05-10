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
    init(name: String, menu: [MenuItem], ingredients: [Ingredient], sections: [MenuSection]) {
        self.id = UUID().uuidString
        self.name = name
        self.menu = menu
        self.ingredients = ingredients
        self.sections = sections
    }
}

extension Restaurant {
    enum CodingKeys: String, CodingKey {
        case id, name, menu, ingredients, sections
    }
}
