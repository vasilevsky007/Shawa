//
//  OrderManager.swift
//  Shawa
//
//  Created by Alex on 30.03.24.
//

import Foundation

@MainActor
protocol OrderManager: ObservableObject {
    var userOrders: Loadable<[Order]> { get }
    var currentOrder: Order { get }
    
    var isCurrentOrderEmpty: Bool { get }
    
    func sendCurrentOrder() async throws
    func getUserOrders(uid: String) async throws
    
    func addOneOrderItem(_ item: Order.Item)
    func removeOneOrderItem(_ item: Order.Item)
    func removeOrderItem(_ item: Order.Item)
    func addOneIngredient(_ ingredient: Ingredient, to item: Order.Item)
    func removeOneIngredient(_ ingredient: Ingredient, from item: Order.Item)
    func updateUserID(_ newValue: String?)
    func updatePhoneNumber(_ newValue: String?)
    func updateAddress(street: String?, house: String?, apartament: String?)
    func updateComment(_ newValue: String?)
    func addTimestamp (date: Date)
}
