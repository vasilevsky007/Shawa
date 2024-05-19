//
//  ShawaAdminAppView.swift
//  ShawaAdmin
//
//  Created by Alex on 2.05.24.
//

import SwiftUI

struct ShawaAdminAppView<RestaurantManagerType: RestaurantManager,
                         OrderManagerType: OrderManager,
                         AuthenticationManagerType: AuthenticationManager>: View {
    @EnvironmentObject private var authenticationManager: AuthenticationManagerType
    
    var body: some View {
        ZStack {
            if authenticationManager.auth.state == .authenticated {
                TabMenuView<RestaurantManagerType, OrderManagerType, AuthenticationManagerType>()
                    .transition(.opacity)
            } else {
                AuthoriseView<AuthenticationManagerType>(isAdmin: true)
                    .transition(.opacity)
            }
            
        }
        .onAppear {
            UIRefreshControl.appearance().tintColor = UIColor(resource: .lightBrown)
        }
    }
}
