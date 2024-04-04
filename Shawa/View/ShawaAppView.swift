//
//  ShawaAppView.swift
//  Shawa
//
//  Created by Alex on 9.04.23.
//

import SwiftUI

struct ShawaAppView<RestaurantManagerType: RestaurantManager, OrderManagerType: OrderManager, AuthenticationManagerType: AuthenticationManager>: View {
    @EnvironmentObject private var restaurantManager: RestaurantManagerType
    @EnvironmentObject private var orderManager: OrderManagerType
    @EnvironmentObject private var authenticationManager: AuthenticationManagerType
    
    var body: some View {
        ZStack {
            if authenticationManager.auth.state == .authenticated {
                MainMenuView<RestaurantManagerType, OrderManagerType, AuthenticationManagerType>()
                    .transition(.opacity)
            } else {
                AuthoriseView<AuthenticationManagerType>()
                    .transition(.opacity)
            }
            
        }
        .preferredColorScheme(.light)
        .onAppear {
            UIRefreshControl.appearance().tintColor = UIColor(.lightBrown)
        }
    }
}
