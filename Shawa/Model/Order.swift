//
//  Order.swift
//  Shawa
//
//  Created by Alex on 18.04.23.
//

import Foundation

struct Order {
    struct Item: Hashable {
        var item: Menu.Item
        var additions: [Menu.Ingredient:Int] // ingredint:count
    }
    struct userData {
        var userID: String?
        var phoneNumber: String?
        var address: String?
    }
    private(set) var orderItems: [Item:Int]
    private(set) var user: userData
    private(set) var comment: String?
    private(set) var timestamp: Date?
    
    init() {
        self.orderItems = [:]
        self.user = userData(userID: "", phoneNumber: nil, address: nil)
    }
    
    
    mutating func addOneItem(_ item: Item) {
        if let currentNumber = orderItems[item] {
            orderItems.updateValue(currentNumber + 1, forKey: item)
        } else {
            orderItems.updateValue(1, forKey: item)
        }
    }
    
    mutating func removeOneItem(_ item: Item) {
        if let currentNumber = orderItems[item] {
            if currentNumber > 1 {
                orderItems.updateValue(currentNumber - 1, forKey: item)
            } else {
                orderItems.removeValue(forKey: item)
            }
        }
    }
    
    mutating func addOneIngredient(_ ingredient: Menu.Ingredient, to item: Item) {
        if let numberOfThisItemsInOrder = orderItems[item] {
            var modfiedItem = item;
            if let currentNumber = modfiedItem.additions[ingredient] {
                modfiedItem.additions.updateValue(currentNumber + 1, forKey: ingredient)
            } else {
                modfiedItem.additions.updateValue(1, forKey: ingredient)
            }
            
            if let numberOfModifiedItemsInOrder = orderItems[modfiedItem] {
                orderItems.updateValue(numberOfModifiedItemsInOrder + numberOfThisItemsInOrder, forKey: modfiedItem)
            } else {
                orderItems.updateValue(numberOfThisItemsInOrder, forKey: modfiedItem)
            }
        }
    }
    
    mutating func removeOneIngredient(_ ingredient: Menu.Ingredient, to item: Item) {
        if let numberOfThisItemsInOrder = orderItems[item] {
            var modfiedItem = item;
            if let currentNumber = modfiedItem.additions[ingredient] {
                if currentNumber > 1 {
                    modfiedItem.additions.updateValue(currentNumber - 1, forKey: ingredient)
                } else {
                    modfiedItem.additions.removeValue(forKey: ingredient)
                }
            } else {
                modfiedItem.additions.updateValue(-1, forKey: ingredient)
            }
            
            if let numberOfModifiedItemsInOrder = orderItems[modfiedItem] {
                orderItems.updateValue(numberOfModifiedItemsInOrder + numberOfThisItemsInOrder, forKey: modfiedItem)
            } else {
                orderItems.updateValue(numberOfThisItemsInOrder, forKey: modfiedItem)
            }
        }
    }
    
    mutating func updateUserID(_ newValue: String?) {
        user.userID = newValue
    }
    
    mutating func updatePhoneNumber(_ newValue: String?) {
        user.phoneNumber = newValue
    }
    
    mutating func updateAddress(_ newValue: String?) {
        user.address = newValue
    }
    
    mutating func updateComment(_ newValue: String?) {
        comment = newValue
    }
    
    mutating func addTimestamp (date: Date) {
        timestamp = date
    }
    
}
