//
//  FirebaseRTDBOrderRepository.swift
//  Shawa
//
//  Created by Alex on 30.03.24.
//

import Foundation
import Firebase

struct FirebaseRTDBOrderRepository {
    private var realtimeDatabase: DatabaseReference
    
    init() {
        self.realtimeDatabase = Database.database(url: "https://"+(Bundle.main.infoDictionary?["FIREBASE_REALTIME_DATABASE_URL"] as? String)!).reference()
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
                .getData().value as! [String:[String:Any]]
        )
            .values
        
        for order in userOrders {
            guard let orderData = try? JSONSerialization.data(withJSONObject: order) else { break }
            guard let orderDecoded = try? JSONDecoder().decode(Order.self, from: orderData) else { break }
            result.append(orderDecoded)
        }
        return result
    }
}
