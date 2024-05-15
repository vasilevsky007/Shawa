//
//  UserOrdersView.swift
//  Shawa
//
//  Created by Alex on 17.11.23.
//

import SwiftUI

struct UserOrdersView<OrderManagerType: OrderManager, RestaurantManagerType: RestaurantManager>: View {
    @EnvironmentObject private var orderManager: OrderManagerType
    
    @Environment(\.dismiss) private var dismiss
    
    let userID: String
    
    func closeThisView () {
        dismiss()
    }
    
    private var backgroundBody: some View {
        Rectangle()
            .ignoresSafeArea()
            .foregroundColor(.white)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            backgroundBody
            VStack(alignment: .leading) {
                Header(leadingIcon: "BackIcon", noTrailingLink: true) {
                    closeThisView()
                } trailingLink: {
                    Text("placeholder. will not be seen")
                }
                .padding(.horizontal, .Constants.horizontalSafeArea)
                
                Text("Your orders:")
                    .foregroundColor(.defaultBrown)
                    .font(.montserratBold(size: 24))
                    .padding(.horizontal, .Constants.horizontalSafeArea)
                    .padding(.top, .Constants.standardSpacing)
                ZStack {
                    RoundedRectangle(cornerRadius: .Constants.blockCornerRadius)
                        .ignoresSafeArea(edges: .bottom)
                        .foregroundColor(.veryLightBrown2)
                    ScrollView {
                        LazyVStack (alignment: .leading, spacing: .Constants.standardSpacing) {
                            ForEach(orderManager.userOrders.sorted(by: { $0.timestamp! > $1.timestamp! })) { order in
                                UserOrder<RestaurantManagerType, OrderManagerType>(order: order)
                            }
                        }.padding(.Constants.horizontalSafeArea)
                    }
                    .refreshControlColor(.defaultBrown)
                }.ignoresSafeArea( .container)
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            
        }
        .backGesture {
            closeThisView()
        }
    }
}

#Preview {
    @ObservedObject var am = AuthenticationManagerStub()
    @ObservedObject var rm = RestaurantManagerStub()
    @ObservedObject var om = OrderManagerStub()
    om.addOneOrderItem(Order.Item(menuItem: rm.allMenuItems.first!, availibleAdditions: rm.restaurants.value!.first!.ingredients))
    
    return UserOrdersView<OrderManagerStub, RestaurantManagerStub>(userID: "1").environmentObject(om).environmentObject(rm)
    
}
