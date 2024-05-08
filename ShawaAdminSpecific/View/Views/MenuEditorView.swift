//
//  MenuEditorView.swift
//  ShawaAdmin
//
//  Created by Alex on 2.05.24.
//

import SwiftUI

struct MenuEditorView<RestaurantManagerType: RestaurantManager,
                      OrderManagerType: OrderManager,
                      AuthenticationManagerType: AuthenticationManager>: View {
    var body: some View {
        Text(verbatim: "MenuEditorView")
    }
}

#Preview {
    MenuEditorView<RestaurantManagerStub, OrderManagerStub, AuthenticationManagerStub>()
        .background(.veryLightBrown2)
        .environmentObject(RestaurantManagerStub())
        .environmentObject(OrderManagerStub())
        .environmentObject(AuthenticationManagerStub())
}
