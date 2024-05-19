//
//  RestaurantMenuView.swift
//  Shawa
//
//  Created by Alex on 14.03.23.
//

import SwiftUI

struct RestaurantMenuView<AuthenticationManagerType: AuthenticationManager,RestaurantManagerType: RestaurantManager, OrderManagerType: OrderManager>: View {
    var restaurantId: String
    @Binding var tappedItem: MenuItem?
    
    @EnvironmentObject private var restaurantManager: RestaurantManagerType
    @EnvironmentObject private var orderManager: OrderManagerType
    @Environment(\.dismiss) private var dismissThisView
    private var restaurant: Restaurant {
        (restaurantManager.restaurants.value?.first(where: { $0.id == restaurantId}))!
    }
    

    
    var body: some View {
        ZStack(alignment: .top) {
            backgroundBody
            VStack(alignment: .leading) {
                Header(leadingIcon: "BackIcon", trailingNumber: orderManager.numberOfItemsInCurrentOrder){ dismissThisView()
                } trailingLink: {
                    CartView<AuthenticationManagerType,RestaurantManagerType, OrderManagerType>()
                }
                .padding(.horizontal, .Constants.horizontalSafeArea)
                
                Text(restaurant.name)
                    .foregroundColor(.defaultBrown)
                    .font(.montserratBold(size: 24))
                    .padding(.top, .Constants.standardSpacing)
                    .frame(maxWidth: .infinity, alignment: .center)
                
////                ScrollView (.horizontal, showsIndicators: false) {
//                    LazyHStack {
//                        //TODO: rework frames
//                        PrettyButton(text: "Filter", systemImage: "slider.vertical.3", unactiveColor: .lightBrown, onTap: {}).padding(.leading, .Constants.blockCornerRadius)
//                            .frame(height: .Constants.lineElementHeight).fixedSize()
//                        PrettyButton(text: "Popularity", isActive: true, onTap: {})
//                            .frame(height: .Constants.lineElementHeight).fixedSize()
//                        PrettyButton(text: "High Price", onTap: {})
//                            .frame(height: .Constants.lineElementHeight).fixedSize()
//                        PrettyButton(text: "Low Price", onTap: {})
//                            .frame(height: .Constants.lineElementHeight).fixedSize()
//                        PrettyButton(text: "Newest", onTap: {})
//                            .frame(height: .Constants.lineElementHeight).fixedSize()
//                        PrettyButton(text: "Oldest", onTap: {})
//                            .frame(height: .Constants.lineElementHeight).fixedSize()
//                    } .frame(height: .Constants.lineElementHeight)
////                }
                .frame(height: .Constants.lineElementHeight)
                ScrollView {
                    LazyVStack(spacing: .Constants.doubleSpacing) {
                        ForEach(restaurant.sections) { thisSection in
                            section(thisSection)
                        }
                    }
                }
            }.ignoresSafeArea(edges: .bottom)
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {}
        .backGesture {
            dismissThisView()
        }
    }
    
    var backgroundBody: some View {
        Rectangle().ignoresSafeArea().foregroundStyle(.background)
    }
    
    @ViewBuilder
    func section(_ section: MenuSection) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: .Constants.blockCornerRadius)
                .ignoresSafeArea(edges: .bottom)
                .padding(.top, .Constants.standardSpacing)
                .foregroundColor(.veryLightBrown2)
            VStack(alignment: .leading) {
                Text(section.name)
                    .foregroundColor(.defaultBrown)
                    .font(.montserratBold(size: 24))
                LazyVGrid(columns: .init(repeating: GridItem(spacing: .Constants.doubleSpacing), count: 2 ), spacing: .Constants.doubleSpacing) {
                    ForEach(restaurant.menu.filter{ $0.sectionIDs.contains(section.id) }) { item in
                        Button {
                            tappedItem = item
                        } label: {
                            MenuItemCard(item)
                                .aspectRatio(62/90, contentMode: .fit)
                        }
                    }
                }
            }.padding(.horizontal, .Constants.tripleSpacing).padding(.vertical, .Constants.quadripleSpacing)
        }
    }
    
}

#Preview {
    @State var tapped: MenuItem? = nil
    @State var rm = RestaurantManagerStub()
    @State var am = AuthenticationManagerStub()
    @State var om = OrderManagerStub()
    
    return RestaurantMenuView<AuthenticationManagerStub,RestaurantManagerStub, OrderManagerStub>(restaurantId: rm.restaurants.value!.first!.id, tappedItem: $tapped)
        .environmentObject(rm)
        .environmentObject(am)
        .environmentObject(om)
}
