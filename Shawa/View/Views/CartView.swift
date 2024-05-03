//
//  CartView.swift
//  Shawa
//
//  Created by Alex on 12.08.23.
//

import SwiftUI

struct CartView<AuthenticationManagerType: AuthenticationManager, RestaurantManagerType: RestaurantManager, OrderManagerType: OrderManager>: View {
    @EnvironmentObject private var orderManager: OrderManagerType
    
    @Environment(\.dismiss) private var dismissThisView
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                backgroundBody
                VStack(alignment: .leading) {
                    Header(leadingIcon: "BackIcon", leadingAction: { dismissThisView() }, noTrailingLink: true) {
                        Text("")
                    }.padding(.horizontal, .Constants.horizontalSafeArea)
                    
                    Text("Your order:")
                        .foregroundColor(Color.defaultBrown)
                        .font(.montserratBold(size: 24))
                        .padding(.horizontal, .Constants.horizontalSafeArea)
                        .padding(.top, .Constants.standardSpacing)
                    ZStack {
                        RoundedRectangle(cornerRadius: .Constants.blockCornerRadius)
                            .ignoresSafeArea(edges: .bottom)
                            .foregroundColor(.veryLightBrown2)
                        VStack (spacing: 0) {//FIXME: alignment: .listRowSeparatorTrailing, spacing: 0) {
                            ScrollView {
                                LazyVStack (spacing: .Constants.doubleSpacing) {
                                    ForEach(Array(orderManager.currentOrder.orderItems.keys)) { item in
                                        OrderItem<RestaurantManagerType, OrderManagerType>(item)
                                    }
                                }
                                .padding(.top, .Constants.tripleSpacing)
                                .padding(.horizontal, .Constants.horizontalSafeArea)
                            }
                            .overlay(alignment: .bottomLeading) {
                                proceedOverlayBody
                            }
                            Divider().overlay(Color.lighterBrown)
                            HStack(alignment: .center, spacing: 0) {
                                Text("Grand total:")
                                    .foregroundColor(.defaultBrown)
                                    .font(.montserratBold(size: 24))
                                    .padding(.trailing, .Constants.standardSpacing)
                                Spacer(minLength: 0)
                                Text(String(format: "%.2f BYN", orderManager.currentOrder.totalPrice))
                                    .foregroundColor(.defaultBrown)
                                    .font(.interBold(size: 20))
                            }
                            .padding(.horizontal, .Constants.horizontalSafeArea)
                            .padding(.bottom, .Constants.standardSpacing)
                            .padding(.vertical, .Constants.standardSpacing)
                        }.ignoresSafeArea(edges: .bottom)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            
        }
        .highPriorityGesture(DragGesture().updating($dragOffset, body: { (value, _, _) in
            if(value.startLocation.x < 50 && value.translation.width > 100) {
                dismissThisView()
            }
        }))
    }
    
    var backgroundBody: some View {
        Rectangle().ignoresSafeArea().foregroundColor(.white)
    }
    
    var proceedOverlayBody: some View {
        NavigationLink {
            OrderView<AuthenticationManagerType,OrderManagerType>()
        } label: {
            if (!orderManager.isCurrentOrderEmpty) {
                ZStack {
                    Capsule()
                        .foregroundColor(.primaryBrown)
                    Capsule()
                        .stroke(lineWidth: .Constants.doubleBorderWidth)
                        .foregroundColor(.lighterBrown)
                    VStack(spacing: 0) {
                        Text("Proceed")
                        Text("to order")
                    }
                    .font(.interBold(size: 16))
                    .foregroundColor(.veryLightBrown2)
                }
            }
        }
        .frame(width: .Constants.CartView.proceedOverlayWidth, height: .Constants.CartView.proceedOverlayHeight)
        .padding(.horizontal, .Constants.horizontalSafeArea)
        .padding(.all, .Constants.halfSpacing)
    }
}

#Preview {
    @ObservedObject var am = AuthenticationManagerStub()
    @ObservedObject var rm = RestaurantManagerStub()
    @ObservedObject var om = OrderManagerStub()
    om.addOneOrderItem(Order.Item(menuItem: rm.allMenuItems.first!, availibleAdditions: rm.restaurants.value!.first!.ingredients))
    return CartView<AuthenticationManagerStub,RestaurantManagerStub, OrderManagerStub>()
        .environmentObject(am)
        .environmentObject(rm)
        .environmentObject(om)
}
