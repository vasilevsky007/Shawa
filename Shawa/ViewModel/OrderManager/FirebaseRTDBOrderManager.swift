//
//  FirebaseRTDBOrderManager.swift
//  Shawa
//
//  Created by Alex on 30.03.24.
//

import Foundation

@MainActor
class FirebaseRTDBOrderManager: OrderManager {
    private var repository = FirebaseRTDBOrderRepository()
    
    @Published private(set) var userOrders: Loadable<[Order]> = .notLoaded(error: nil)
    @Published private(set) var currentOrder = Order()
    
    private func updateUserOrders(newOrders: Loadable<[Order]>) {
        userOrders = newOrders
    }
    
    func sendCurrentOrder() async throws {
        let sendTask = Task.detached {
            try await self.repository.sendOrder(self.currentOrder)
        }
        try await sendTask.result.get()
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
}
