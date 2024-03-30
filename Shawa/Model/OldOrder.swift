//
//  OldOrder.swift
//  Shawa
//
//  Created by Alex on 18.04.23.
//

import Foundation

struct OldOrder: Codable, Hashable {
    struct Item: Hashable, Identifiable, Codable {
        var id = UUID()
        var item: Menu.Item
        var additions: [Menu.Ingredient:Int] // ingredint:count
        var price: Double {
            var price = self.item.price
            for additionQuantity in additions.values {
                price += (additionQuantity > 0 ? Double(additionQuantity) : 0) * Menu.Ingredient.price
            }
            return price
        }
    }
    struct Address: Codable, Hashable {
        var street: String?
        var house: String?
        var apartament: String?
    }
    struct UserData: Codable, Hashable {
        var userID: String?
        var phoneNumber: String?
        var address: Address
    }
    
    private(set) var orderItems: [Item:Int]
    private(set) var user: UserData
    private(set) var comment: String?
    private(set) var timestamp: Date?
    
    var totalPrice: Double {
        var totalPrice = 0.0
        for item in orderItems {
            totalPrice += item.key.price * Double(item.value)
        }
        return totalPrice
    }
    
    init() {
        self.orderItems = [:]
        self.user = UserData(userID: "", phoneNumber: nil, address: Address())
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
            if let currentNumber = modfiedItem.additions[ingredient] {
                modfiedItem.additions.updateValue(currentNumber + 1, forKey: ingredient)
            } else {
                modfiedItem.additions.updateValue(1, forKey: ingredient)
            }
            orderItems.updateValue(numberOfThisItemsInOrder, forKey: modfiedItem)
        }
    }
    
    mutating func removeOneIngredient(_ ingredient: Menu.Ingredient, to item: Item) {
        if let numberOfThisItemsInOrder = orderItems[item] {
            var modfiedItem = item;
            orderItems.removeValue(forKey: item)
            if let currentNumber = modfiedItem.additions[ingredient] {
                if currentNumber > 1 {
                    modfiedItem.additions.updateValue(currentNumber - 1, forKey: ingredient)
                } else {
                    modfiedItem.additions.removeValue(forKey: ingredient)
                }
            } else {
                modfiedItem.additions.updateValue(-1, forKey: ingredient)
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
