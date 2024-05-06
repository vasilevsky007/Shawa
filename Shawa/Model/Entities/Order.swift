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
        ///ingredientID : count
        private(set) var additions: [String:Int]
        private(set) var price: Double
        ///computed, menuitem ID+ additionIDs : counts
        var id: String {
            var result = itemID
            for (ingredientID, count) in additions {
                result += " " + ingredientID + ":" + String(count)
            }
            return result
        }
        
        init(menuItem: MenuItem, availibleAdditions: [Ingredient]) {
            itemID = menuItem.id
            price = menuItem.price
            additions = [String:Int]()
            for addition in availibleAdditions {
                additions.updateValue(0, forKey: addition.id)
            }
        }
        
        mutating func addOneIngredient(_ ingredient: Ingredient) {
            if let currentNumber = self.additions[ingredient.id] {
                self.additions.updateValue(currentNumber + 1, forKey: ingredient.id)
                self.price += currentNumber < 0 ? 0 : ingredient.cost
            } else {
                self.additions.updateValue(1, forKey: ingredient.id)
                self.price += ingredient.cost
            }
        }
        
        mutating func removeOneIngredient(_ ingredient: Ingredient) {
            if let currentNumber = self.additions[ingredient.id] {
                if currentNumber > 0 {
                    self.additions.updateValue(currentNumber - 1, forKey: ingredient.id)
                    self.price -= ingredient.cost
                } else {
                    if currentNumber == 0 {
                        self.additions.updateValue(-1, forKey: ingredient.id)
                    }
                }
            } else {
                self.additions.updateValue(-1, forKey: ingredient.id)
            }
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
    
    enum OrderState: String, Codable, CaseIterable {
        case sended, confirmed, delivering, delivered, cancelled
    }
    
    private(set) var id = UUID()
    private(set) var orderItems: [Item:Int]
    private(set) var user: UserData
    private(set) var comment: String?
    private(set) var timestamp: Date?
    private(set) var state: OrderState?
    
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
        self.state = nil
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
    
    mutating func addOneIngredient(_ ingredient: Ingredient, to item: Item) {
        if let numberOfThisItemsInOrder = orderItems[item] {
            var modifiedItem = item
            modifiedItem.addOneIngredient(ingredient)
            orderItems.removeValue(forKey: item)
            orderItems.updateValue(numberOfThisItemsInOrder, forKey: modifiedItem)
        }
    }
    
    mutating func removeOneIngredient(_ ingredient: Ingredient, from item: Item) {
        if let numberOfThisItemsInOrder = orderItems[item] {
            var modifiedItem = item;
            modifiedItem.removeOneIngredient(ingredient)
            orderItems.removeValue(forKey: item)
            orderItems.updateValue(numberOfThisItemsInOrder, forKey: modifiedItem)
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
    
    mutating func updateState (_ newValue: OrderState) {
        state = newValue
    }
}

extension Order.OrderState {
    var description: String {
        switch self {
        case .sended:
            "Order sended"
        case .confirmed:
            "Order confirmed"
        case .delivering:
            "Sent for delivery"
        case .delivered:
            "Order delivered"
        case .cancelled:
            "Order cancelled"
        }
    }
}
