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
//    @State var am: AuthenticationManagerStub
//    @State var rm :  RestaurantManagerStub
//    @State var om :  OrderManagerStub
    init () {
        FirebaseApp.configure()
        restaurantManager = FirestoreRestaurantManager()
        orderManager = FirebaseRTDBOrderManager()
        authenticationManager = FirebaseAuthenticationManager()
//        am = AuthenticationManagerStub()
//        rm = RestaurantManagerStub()
//        om  = OrderManagerStub()
//        om.addOneOrderItem(Order.Item(menuItem: rm.allMenuItems.first!, availibleAdditions: rm.restaurants.value!.first!.ingredients))
        Font.printAllFonts()
    }
    
    var body: some Scene {
        WindowGroup {
//            UserOrdersView<OrderManagerStub, RestaurantManagerStub>(userID: "1").environmentObject(om).environmentObject(rm)
            ShawaAppView<FirestoreRestaurantManager, FirebaseRTDBOrderManager, FirebaseAuthenticationManager>()
                .environmentObject(restaurantManager)
                .environmentObject(orderManager)
                .environmentObject(authenticationManager)
        }
    }
}
