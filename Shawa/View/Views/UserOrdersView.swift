//
//  UserOrdersView.swift
//  Shawa
//
//  Created by Alex on 17.11.23.
//

import SwiftUI

fileprivate struct DrawingConstants {
    static let gridSpacing: CGFloat = 16
    static let pagePadding: CGFloat = 24
    static let padding: CGFloat = 8
    static let cornerRadius: CGFloat = 30
    static let headlineFontSize: CGFloat = 24
}

struct UserOrdersView<OrderManagerType: OrderManager, RestaurantManagerType: RestaurantManager>: View {
    @EnvironmentObject private var orderManager: OrderManagerType
    
    @Environment(\.dismiss) private var dismiss
    @GestureState private var dragOffset = CGSize.zero
    
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
                Header(leadingIcon: "BackIcon", leadingAction: {
                    closeThisView()
                }, noTrailingLink: true) {
                    Text("placeholder. will not be seen")
                }.padding(.horizontal, 24.5)
                
                Text("Your orders:")
                    .foregroundColor(.deafultBrown)
                    .font(.montserratBold(size: 24))
                    .padding(.horizontal, DrawingConstants.pagePadding)
                    .padding(.top, DrawingConstants.padding)
                ZStack {
                    RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                        .ignoresSafeArea(edges: .bottom)
                        .foregroundColor(.veryLightBrown2)
                    ScrollView {
                        LazyVStack (alignment: .leading, spacing: 8) {
                            fetchingProgressBody
                            if let orders = orderManager.userOrders.value {
                                ForEach(orders.sorted(by: { $0.timestamp! > $1.timestamp! })) { order in
                                    UserOrder<RestaurantManagerType>(order: order)
                                }
                            }
                        }.padding(DrawingConstants.pagePadding)
                    }
                    .refreshControlColor(.deafultBrown)
                    .refreshable {
                        //TODO: load orders from firebase
                        try? await orderManager.getUserOrders(uid: userID)
                    }
                }.ignoresSafeArea( .container)
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            
        }
        .highPriorityGesture(DragGesture().updating($dragOffset, body: { (value, _, _) in
            if(value.startLocation.x < 50 && value.translation.width > 100) {
                closeThisView()
            }
        }))
        .task {
            //TODO: load orders from firebase
            try? await orderManager.getUserOrders(uid: userID)
        }
    }
    
    var fetchingProgressBody: some View {
        ZStack {
            if (orderManager.userOrders.isLoading) {
                HStack(spacing: 0){
                    Spacer(minLength: 0)
                    ProgressView()
                        .tint(.deafultBrown)
                        .scaleEffect(1.5)
                    Spacer(minLength: 0)
                }.transition(.asymmetric(
                    insertion: .opacity.animation(.linear(duration: 1)),
                    removal: .identity))
            }
            Color.clear
        }
        .frame(minWidth: 0, minHeight: orderManager.userOrders.isLoading ? 30 : 0)
    }
}

#Preview {
    @ObservedObject var am = AuthenticationManagerStub()
    @ObservedObject var rm = RestaurantManagerStub()
    @ObservedObject var om = OrderManagerStub()
    om.addOneOrderItem(Order.Item(menuItem: rm.allMenuItems.first!, availibleAdditions: rm.restaurants.value!.first!.ingredients))
    
    return UserOrdersView<OrderManagerStub, RestaurantManagerStub>(userID: "1").environmentObject(om).environmentObject(rm)
    
}
