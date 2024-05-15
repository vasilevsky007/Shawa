//
//  FirebaseRTDBOrderManager.swift
//  Shawa
//
//  Created by Alex on 30.03.24.
//

import SwiftUI

@MainActor
class FirebaseRTDBOrderManager: OrderManager {
    private var repository = FirebaseRTDBOrderRepository()
    private var userIdListeningOrders: String?
    
    @Published private(set) var userOrders = [Order]()
    @Published private(set) var currentOrder = Order()
    @Published private(set) var allOrders = [Order]()
    
    var numberOfActiveOrdersForUser: Int {
        var result = 0
        for order in userOrders {
            if order.state == .sended || order.state == .confirmed || order.state == .delivering {
                result += 1
            }
        }
        return result
    }
    
    var numberOfActiveOrdersForAdmin: Int {
        var result = 0
        for order in allOrders {
            if order.state == .sended || order.state == .confirmed || order.state == .delivering {
                result += 1
            }
        }
        return result
    }
    
    var numberOfItemsInCurrentOrder: Int {
        currentOrder.orderItems.count
    }
    
    var isCurrentOrderEmpty: Bool {
        currentOrder.orderItems.isEmpty
    }
    
    init(isAdmin: Bool = false) {
        if (isAdmin) {
            repository.startListeningToALLOrders{ [weak self] orders in
                Task {
                    withAnimation {
                        self?.allOrders = orders.sorted{ order1, order2 in
                            if let time1 = order1.timestamp, let time2 = order2.timestamp {
                                return time1 < time2
                            }
                            return true
                        }
                    }
                }
            }
        }
    }
    
    deinit {
        repository.stopListeningToALLOrders()
        guard let userIdListeningOrders = userIdListeningOrders else { return }
        repository.stopListeningToUserOrders(userID: userIdListeningOrders)
    }
    
    func startListeningToUserOrders(userID: String) {
        stopListeningToUserOrders()
        userIdListeningOrders = userID
        repository.startListeningToUserOrders(userID: userID) { [weak self] orders in
            Task {
                withAnimation {
                    self?.userOrders = orders.sorted{ order1, order2 in
                        if let time1 = order1.timestamp, let time2 = order2.timestamp {
                            return time1 < time2
                        }
                        return true
                    }
                }
            }
        }
    }
    
    func stopListeningToUserOrders() {
        guard let userIdListeningOrders = userIdListeningOrders else { return }
        repository.stopListeningToUserOrders(userID: userIdListeningOrders)
        self.userIdListeningOrders = nil
    }
    
    private func updateUserOrders(newOrders: [Order]) {
        withAnimation {
            userOrders = newOrders
        }
    }
    
    func sendCurrentOrder() async throws {
        currentOrder.addTimestamp(date: .now)
        currentOrder.updateState(.sended)
        let sendTask = Task.detached {
            try await self.repository.sendOrder(self.currentOrder)
        }
        try await sendTask.result.get()
        currentOrder = Order()
    }
    
    func updateOrderState(to state: Order.OrderState, in order: Order) async throws {
        let sendTask = Task.detached {
            try await self.repository.updateOrderState(to: state, in: order)
        }
        try await sendTask.result.get()
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
            currentOrder.updateAddress(street: street, house: house, apartament: apartament == "" ? nil : apartament)
        }
    }
    
    func updateComment(_ newValue: String?) {
        withAnimation {
            currentOrder.updateComment(newValue == "" ? nil : newValue)
        }
    }
    
    func addTimestamp(date: Date) {
        withAnimation {
            currentOrder.addTimestamp(date: date)
        }
    }
}
