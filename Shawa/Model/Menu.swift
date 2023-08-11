//
//  Menu.swift
//  Shawa
//
//  Created by Alex on 12.03.23.
//

import Foundation
import UIKit //TODO: Remove

struct Menu {
    enum Section: String, CaseIterable, Codable {
        case Shawarma
        case Sushi
        case Pizza
        case Drinks
    }
    
    enum Ingredient: String, CaseIterable, Codable {
        case Chiken
        case FreshTomatoes
        case FreshCucumbers
        case PickledCucumbers
        case HalapenyoPepper
        case Cheese
        case Onion
        case Mushrooms
        case Lamb
        case Pork
        case Beef
        
        var name: String {
            var name = ""
            self.rawValue.map { character in
                if character.isUppercase {
                    name.append(" ")
                }
                name.append(character)
            }
            name.removeFirst()
            return name
        }
        
        static func random() -> Self {
            let randomNmber = Int.random(in: Self.allCases.indices)
            return Self.allCases[randomNmber]
        }
        
    }
    
    struct Item: Identifiable, Hashable, Codable {
        var id: Int
        var belogsTo: Section
        var name: String
        var price: Double
        var image: Data?
        var dateAdded: Date
        var popularity: Int //here smth like number of additions to cart/purchases
        var ingredients: Set<Ingredient>
        var description: String
    }
    
    private(set) var items: Set<Item>
    
    init() {
        var id = 0
        items = []
        for section in Section.allCases {
            for itemNumber in 0..<10 {
                var ingredients: Set<Ingredient> = []
                for _ in 1...Int.random(in: 1..<Ingredient.allCases.count) {
                    ingredients.insert(Ingredient.random())
                }
                items.insert(Item(
                    id: id,
                    belogsTo: section,
                    name: section.rawValue + String(itemNumber),
                    price: Double.random(in: 0...100),
                    image: UIImage(named: section.rawValue + "Picture")!.pngData()!,
                    dateAdded: Date(),
                    popularity: 1,
                    ingredients: ingredients,
                    description: "asdkjkcjd fhqwkdjl;cd qhewjkldm; hwdklqm;dq'"
                ))
                id += 1
            }
        }
    }
    
    mutating func clearMenu() {
        items = Set([])
    }
    
    mutating func addItem(_ item: Item) {
        items.insert(item)
    }
}

