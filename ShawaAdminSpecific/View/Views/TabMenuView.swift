//
//  TabMenuView.swift
//  Shawa
//
//  Created by Alex on 2.05.24.
//

import SwiftUI

struct TabMenuView<RestaurantManagerType: RestaurantManager,
                   OrderManagerType: OrderManager,
                   AuthenticationManagerType: AuthenticationManager>: View {
    var body: some View {
        TabView {
            ZStack(alignment: .top) {
                Color.veryLightBrown2
                    .ignoresSafeArea()
                ReceivedOrdersListView<RestaurantManagerType, OrderManagerType, AuthenticationManagerType>()
            }
                .tabItem {
                    VStack(alignment: .center) {
                        Text("Received orders")
                            .font(.mainBold(size: 16))
                        Image(.cartIcon)
                            .renderingMode(.template)
                    }
                }
            ZStack(alignment: .top) {
                Color.veryLightBrown2
                    .ignoresSafeArea()
                MenuEditorView<RestaurantManagerType, OrderManagerType, AuthenticationManagerType>()
            }
                .tabItem {
                    VStack(alignment: .center) {
                        Text("Menu edit")
                            .font(.mainBold(size: 16))
                        Image(.menuIcon)
                            .renderingMode(.template)
                    }
                }
        }
        .onAppear{
            UITabBar.appearance().unselectedItemTintColor = .lighterBrown
            UITabBar.appearance().backgroundColor = .systemBackground
        }
    }
}

#Preview {
    @ObservedObject var am = AuthenticationManagerStub()
    @ObservedObject var rm = RestaurantManagerStub()
    @ObservedObject var om = OrderManagerStub()
    
    return TabMenuView<RestaurantManagerStub, OrderManagerStub, AuthenticationManagerStub>()
        .environmentObject(rm)
        .environmentObject(om)
        .environmentObject(am)
}
