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
    
    @Published private(set) var userOrders: Loadable<[Order]> = .notLoaded(error: nil)
    @Published private(set) var currentOrder = Order()
    
    var isCurrentOrderEmpty: Bool {
        currentOrder.orderItems.isEmpty
    }
    
    private func updateUserOrders(newOrders: Loadable<[Order]>) {
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
    
    func getUserOrders(uid: String) async throws {
        updateUserOrders(newOrders: .loading(last: userOrders.value))
        Task.detached {
            do {
                let ordersLoaded = try await self.repository.getUserOrders(userID: uid)
                Task {
                    await self.updateUserOrders(newOrders: .loaded(ordersLoaded))
                }
            } catch {
                Task {
                    await self.updateUserOrders(newOrders: .notLoaded(error: error))
                }
            }
        }
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
