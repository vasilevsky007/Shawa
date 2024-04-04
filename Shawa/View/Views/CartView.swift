//
//  CartView.swift
//  Shawa
//
//  Created by Alex on 12.08.23.
//

import SwiftUI

fileprivate struct DrawingConstants {
    static let gridSpacing: CGFloat = 16
    static let pagePadding: CGFloat = 24
    static let padding: CGFloat = 8
    static let cornerRadius: CGFloat = 30
    static let headlineFontSize: CGFloat = 24
}

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
                        Text("placeholder. will not be seen")
                    }.padding(.horizontal, 24.5)
                    
                    Text("Your order:")
                        .foregroundColor(.deafultBrown)
                        .font(.montserratBold(size: 24))
                        .padding(.horizontal, DrawingConstants.pagePadding)
                        .padding(.top, DrawingConstants.padding)
                    ZStack {
                        RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                            .ignoresSafeArea(edges: .bottom)
                            .foregroundColor(.veryLightBrown2)
                        VStack (spacing: 0) {//FIXME: alignment: .listRowSeparatorTrailing, spacing: 0) {
                            ScrollView {
                                LazyVStack (spacing: DrawingConstants.gridSpacing) {
                                    ForEach(Array(orderManager.currentOrder.orderItems.keys)) { item in
                                        OrderItem<RestaurantManagerType, OrderManagerType>(item)
                                    }
                                }
                                .padding(.top, DrawingConstants.pagePadding)
                                .padding(.horizontal, DrawingConstants.pagePadding)
                            }
                            .overlay(alignment: .bottomLeading) {
                                proceedOverlayBody
                            }
                            Divider().overlay(Color.lighterBrown)
                            HStack(alignment: .center, spacing: 0) {
                                Text("Grand total:")
                                    .foregroundColor(.deafultBrown)
                                    .font(.montserratBold(size: DrawingConstants.headlineFontSize))
                                    .padding(.trailing, DrawingConstants.padding)
                                Spacer(minLength: 0)
                                Text(String(format: "%.2f BYN", orderManager.currentOrder.totalPrice))
                                    .foregroundColor(.deafultBrown)
                                    .font(.interBold(size: 20))
                            }
                            .padding(.horizontal, DrawingConstants.pagePadding)
                            .padding(.bottom, DrawingConstants.padding)
                            .padding(.vertical, DrawingConstants.padding)
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
                        .stroke(lineWidth: 2)
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
        .frame(width: 100, height: 50)
        .padding(.horizontal, DrawingConstants.pagePadding)
        .padding(.all, DrawingConstants.padding / 2)
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
