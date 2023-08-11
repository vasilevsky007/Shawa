//
//  Order.swift
//  Shawa
//
//  Created by Alex on 18.04.23.
//

import Foundation

struct Order {
    struct Item {
        var item: Menu.Item
        var additions: [Menu.Ingredient:Int] // ingredint:count
    }
    
    var orderItems: [Item]
    var user: String
    var comment: String
}
