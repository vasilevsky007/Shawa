//
//  UserOrders.swift
//  Shawa
//
//  Created by Alex on 17.11.23.
//

import Foundation

struct UserOrders {
    private(set) var orders: Set<Order>
    
    init() {
        orders = Set([])
    }
    
    mutating func clearOrders() {
        orders = Set([])
    }
    
    mutating func addOrder(_ order: Order) {
        orders.insert(order)
    }
}
