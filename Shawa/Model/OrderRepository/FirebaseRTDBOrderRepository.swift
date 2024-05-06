//
//  FirebaseRTDBOrderRepository.swift
//  Shawa
//
//  Created by Alex on 30.03.24.
//

import Foundation
import Firebase

struct FirebaseRTDBOrderRepository: OrderRepository {
    private var realtimeDatabase: DatabaseReference
    
    init() {
        var urlFromPlist: String? {
            guard let path = Bundle.main.path(forResource: "RTDBSettings", ofType: "plist"),
                  let dict = NSDictionary(contentsOfFile: path),
                  let url = dict["FIREBASE_REALTIME_DATABASE_URL"] as? String else {
                return nil
            }
            return url
        }
        self.realtimeDatabase = Database.database(url: urlFromPlist!).reference()
    }
    
    func sendOrder(_ order: Order) async throws {
        let orderJson = try JSONEncoder().encode(order)
        let orderSerialized = try JSONSerialization.jsonObject(with: orderJson)
        try await realtimeDatabase.child("orders")
            .child(order.user.userID ?? "unknown")
            .child(order.id.uuidString)
            .setValue(orderSerialized)
    }
    
    func getUserOrders(userID: String) async throws -> [Order] {
        var result = [Order]()
        let userOrders = (
            try await realtimeDatabase
                .child("orders")
                .child(userID)
                .getData().value as? [String:[String:Any]]
        )?.values
        if let userOrders = userOrders {
            for order in userOrders {
                guard let orderData = try? JSONSerialization.data(withJSONObject: order) else { break }
                guard let orderDecoded = try? JSONDecoder().decode(Order.self, from: orderData) else { break }
                result.append(orderDecoded)
            }
        }
        return result
    }
    
    func startListeningToALLOrders(publishNewOrders: @escaping ([Order]) -> Void) {
        realtimeDatabase
            .child("orders")
            .observe(.value) { snapshot in
                let orders = Self.processAllOrders(snapshot: snapshot)
                publishNewOrders(orders)
            }
    }
    
    func stopListeningToALLOrders() {
        realtimeDatabase
            .child("orders")
            .removeAllObservers()
    }
    
    func updateOrderState(to state: Order.OrderState, in order: Order) async throws {
        try await realtimeDatabase.child("orders")
            .child(order.user.userID ?? "unknown")
            .child(order.id.uuidString)
            .child("state")
            .setValue(state.rawValue)
    }
    
    private static func processAllOrders(snapshot: DataSnapshot) -> [Order] {
        var result = [Order]()
        let ordersByUsers = (
            snapshot.value as? [String:[String:[String:Any]]]
        )?.values
        if let ordersByUsers = ordersByUsers {
            
            let ordersByIds = ordersByUsers.map { ordersByUser in
                ordersByUser.values
            }
            var ordersArray = [[String:Any]]()
            for i in ordersByIds.indices {
                for i2 in ordersByIds[i].indices {
                    ordersArray.append(ordersByIds[i][i2])
                }
            }
            for order in ordersArray {
                guard let orderData = try? JSONSerialization.data(withJSONObject: order) else { break }
                guard let orderDecoded = try? JSONDecoder().decode(Order.self, from: orderData) else { break }
                result.append(orderDecoded)
            }
        }
        return result
    }
}
