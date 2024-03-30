//
//  Order.swift
//  Shawa
//
//  Created by Alex on 30.03.24.
//

import Foundation

struct Order: Codable, Identifiable {
    struct Item: Hashable, Identifiable, Codable {
        var itemID: String
        var additions: [String:Int] // ingredint:count
//        FIXME: price calculation
        var price: Double
        var id: String {
            var result = itemID
            for (ingredientID, count) in additions {
                result += " " + ingredientID + ":" + String(count)
            }
            return result
        }
    }
    
    struct Address: Codable {
        var street: String?
        var house: String?
        var apartament: String?
    }
    
    struct UserData: Codable {
        var userID: String?
        var phoneNumber: String?
        var address: Address
    }
    
    private(set) var id = UUID()
    private(set) var orderItems: [Item:Int]
    private(set) var user: UserData
    private(set) var comment: String?
    private(set) var timestamp: Date?
    
    var totalPrice: Double {
        var totalPrice = 0.0
        for (item, count) in orderItems {
            totalPrice += item.price * Double(count)
        }
        return totalPrice
    }
    
    init() {
        self.orderItems = [:]
        self.user = UserData(userID: "userid", phoneNumber: nil, address: Address())
    }
    
    
    mutating func addOneOrderItem(_ item: Item) {
        if let currentNumber = orderItems[item] {
            orderItems.updateValue(currentNumber + 1, forKey: item)
        } else {
            orderItems.updateValue(1, forKey: item)
        }
    }
    
    mutating func removeOneOrderItem(_ item: Item) {
        if let currentNumber = orderItems[item] {
            if currentNumber > 1 {
                orderItems.updateValue(currentNumber - 1, forKey: item)
            } else {
                orderItems.removeValue(forKey: item)
            }
        }
    }
    
    mutating func removeOrderItem(_ item: Item) {
        orderItems.removeValue(forKey: item)
    }
    
    mutating func clearCart() {
        orderItems.removeAll()
    }
    
    mutating func addOneIngredient(_ ingredient: Menu.Ingredient, to item: Item) {
        if let numberOfThisItemsInOrder = orderItems[item] {
            var modfiedItem = item;
            orderItems.removeValue(forKey: item)
            if let currentNumber = modfiedItem.additions[ingredient.id] {
                modfiedItem.additions.updateValue(currentNumber + 1, forKey: ingredient.id)
            } else {
                modfiedItem.additions.updateValue(1, forKey: ingredient.id)
            }
            orderItems.updateValue(numberOfThisItemsInOrder, forKey: modfiedItem)
        }
    }
    
    mutating func removeOneIngredient(_ ingredient: Menu.Ingredient, to item: Item) {
        if let numberOfThisItemsInOrder = orderItems[item] {
            var modfiedItem = item;
            orderItems.removeValue(forKey: item)
            if let currentNumber = modfiedItem.additions[ingredient.id] {
                if currentNumber > 1 {
                    modfiedItem.additions.updateValue(currentNumber - 1, forKey: ingredient.id)
                } else {
                    modfiedItem.additions.removeValue(forKey: ingredient.id)
                }
            } else {
                modfiedItem.additions.updateValue(-1, forKey: ingredient.id)
            }
            orderItems.updateValue(numberOfThisItemsInOrder, forKey: modfiedItem)
        }
    }
    
    mutating func updateUserID(_ newValue: String?) {
        user.userID = newValue
    }
    
    mutating func updatePhoneNumber(_ newValue: String?) {
        user.phoneNumber = newValue
    }
    
    mutating func updateAddress(street: String?, house: String?, apartament: String?) {
        user.address.street = street
        user.address.house = house
        user.address.apartament = apartament
    }
    
    mutating func updateComment(_ newValue: String?) {
        comment = newValue
    }
    
    mutating func addTimestamp (date: Date) {
        timestamp = date
    }
}
