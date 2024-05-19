//
//  ShawaApp.swift
//  Shawa
//
//  Created by Alex on 10.03.23.
//

import SwiftUI
import FirebaseCore


@main
struct ShawaApp: App {
    @State var restaurantManager: FirestoreRestaurantManager
    @State var orderManager: FirebaseRTDBOrderManager
    @State var authenticationManager: FirebaseAuthenticationManager
    
    init () {
        FirebaseApp.configure()
        restaurantManager = FirestoreRestaurantManager()
        orderManager = FirebaseRTDBOrderManager()
        authenticationManager = FirebaseAuthenticationManager()
    }
    
    var body: some Scene {
        WindowGroup {
            ShawaAppView<FirestoreRestaurantManager, FirebaseRTDBOrderManager, FirebaseAuthenticationManager>()
                .environmentObject(restaurantManager)
                .environmentObject(orderManager)
                .environmentObject(authenticationManager)
        }
    }
}
