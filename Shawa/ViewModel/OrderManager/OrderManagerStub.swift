//
//  OrderManagerStub.swift
//  Shawa
//
//  Created by Alex on 31.03.24.
//

import SwiftUI

@MainActor
class OrderManagerStub: OrderManager {
    var numberOfActiveOrdersForUser: Int {
        var result = 0
        for order in userOrders {
            if order.state == .sended || order.state == .confirmed || order.state == .delivering {
                result += 1
            }
        }
        return 2
    }
    var numberOfActiveOrdersForAdmin: Int {
        var result = 0
        for order in userOrders {
            if order.state == .sended || order.state == .confirmed || order.state == .delivering {
                result += 1
            }
        }
        return result
    }
    
    var numberOfItemsInCurrentOrder: Int {
        currentOrder.orderItems.count
        return 99
    }
    
    
    @Published private(set) var userOrders: [Order] = [
        order, order, order, order
    ]
    
    @Published private(set) var currentOrder: Order = .init()
    
    @Published private(set) var allOrders: [Order] = []
    
    func sendCurrentOrder() async throws {
        print(currentOrder)
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        throw DecodingError.dataCorrupted(.init(codingPath: .init(), debugDescription: "xdddddd"))
    }
    
    func startListeningToUserOrders(userID: String) {
        
    }
    
    func stopListeningToUserOrders() {
        
    }
    
    func updateOrderState(to state: Order.OrderState, in order: Order) async throws {
        guard let index = allOrders.firstIndex(where: { $0.id == order.id }) else { return }
        allOrders[index].updateState(state)
    }
    
    var isCurrentOrderEmpty: Bool {
        currentOrder.orderItems.isEmpty
    }
    
    func addOneOrderItem(_ item: Order.Item) {
        withAnimation {
            currentOrder.addOneOrderItem(item)
        }
    }
    
    func removeOneOrderItem(_ item: Order.Item) {
        withAnimation {
            currentOrder.removeOneOrderItem(item)
        }
    }
    
    func removeOrderItem(_ item: Order.Item) {
        withAnimation {
            currentOrder.removeOrderItem(item)
        }
    }
    
    func addOneIngredient(_ ingredient: Ingredient, to item: Order.Item) {
        withAnimation {
            currentOrder.addOneIngredient(ingredient, to: item)
        }
    }
    
    func removeOneIngredient(_ ingredient: Ingredient, from item: Order.Item) {
        withAnimation {
            currentOrder.removeOneIngredient(ingredient, from: item)
        }
    }
    
    func updateUserID(_ newValue: String?) {
        withAnimation {
            currentOrder.updateUserID(newValue)
        }
    }
    
    func updatePhoneNumber(_ newValue: String?) {
        withAnimation {
            currentOrder.updatePhoneNumber(newValue)
        }
    }
    
    func updateAddress(street: String?, house: String?, apartament: String?) {
        withAnimation {
            currentOrder.updateAddress(street: street, house: house, apartament: apartament)
        }
    }
    
    func updateComment(_ newValue: String?) {
        withAnimation {
            currentOrder.updateComment(newValue)
        }
    }
    
    func addTimestamp(date: Date) {
        withAnimation {
            currentOrder.addTimestamp(date: date)
        }
    }
    private static var offset: TimeInterval = 0
    private static var order: Order {
        let rm = RestaurantManagerStub()
        var o = Order()
        o.addOneOrderItem(.init(menuItem: rm.allMenuItems.first!, availibleAdditions: rm.restaurants.value!.first!.ingredients))
        o.updateAddress(street: "str Asd", house: "h 8", apartament: "ap 12")
        o.updateComment("order comment xddd")
        o.addTimestamp(date: .now.addingTimeInterval(offset))
        offset -= 10000
        o.addOneIngredient(rm.restaurants.value!.first!.ingredients.first!, to: o.orderItems.first!.key)
        return o
    }
}
