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
    func sendCurrentOrder() async throws
    func getUserOrders(uid: String) async throws
}
