//
//  OrderRepository.swift
//  Shawa
//
//  Created by Alex on 30.03.24.
//

import Foundation

protocol OrderRepository {
    func sendOrder(_ order: Order) async throws
    func getUserOrders(userID: String) async throws -> [Order]
}
