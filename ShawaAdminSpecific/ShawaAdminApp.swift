//
//  ShawaAdminApp.swift
//  ShawaAdmin
//
//  Created by Alex on 2.05.24.
//

import SwiftUI
import FirebaseCore

@main
struct ShawaAdminApp: App {
    @State var restaurantManager: FirestoreRestaurantManager
    @State var orderManager: FirebaseRTDBOrderManager
    @State var authenticationManager: FirebaseAuthenticationManager
    init () {
        FirebaseApp.configure()
        restaurantManager = FirestoreRestaurantManager()
        orderManager = FirebaseRTDBOrderManager(isAdmin: true)
        authenticationManager = FirebaseAuthenticationManager()
    }
    
    var body: some Scene {
        WindowGroup {
            ShawaAdminAppView<FirestoreRestaurantManager, FirebaseRTDBOrderManager, FirebaseAuthenticationManager>()
                .environmentObject(restaurantManager)
                .environmentObject(orderManager)
                .environmentObject(authenticationManager)
        }
    }
}
