//
//  OrderManager.swift
//  Shawa
//
//  Created by Alex on 30.03.24.
//

import Foundation

@MainActor
protocol OrderManager: ObservableObject {
    var userOrders: [Order] { get }
    var currentOrder: Order { get }
    var allOrders: [Order] { get }
    
    var numberOfActiveOrdersForUser: Int { get }
    var numberOfActiveOrdersForAdmin: Int { get }
    var numberOfItemsInCurrentOrder: Int { get }
    var isCurrentOrderEmpty: Bool { get }
    
    func sendCurrentOrder() async throws
    func updateOrderState(to state: Order.OrderState, in order: Order) async throws
    func startListeningToUserOrders(userID: String)
    func stopListeningToUserOrders()
    
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
