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
    @Environment(\.dismiss) private var dismissThisView
    @GestureState private var dragOffset = CGSize.zero
    private var restaurant: Restaurant {
        (restaurantManager.restaurants.value?.first(where: { $0.id == restaurantId}))!
    }
    

    
    var body: some View {
        ZStack(alignment: .top) {
            backgroundBody
            VStack(alignment: .leading) {
                Header(leadingIcon: "BackIcon", leadingAction: { dismissThisView() }){
                    CartView<AuthenticationManagerType,RestaurantManagerType, OrderManagerType>()
                }.padding(.horizontal, .Constants.horizontalSafeArea)
                
                Text(restaurant.name)
                    .foregroundColor(.defaultBrown)
                    .font(.montserratBold(size: 24))
                    .padding(.top, .Constants.standardSpacing)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                ScrollView (.horizontal, showsIndicators: false) {
                    LazyHStack {
                        //TODO: rework frames
                        PrettyButton(text: "Filter", systemImage: "slider.vertical.3", unactiveColor: .lightBrown, onTap: {}).frame(width: 96, height: 40).padding(.leading, 24.5)
                        PrettyButton(text: "Popularity", isActive: true, onTap: {}).frame(width: 96, height: 40)
                        PrettyButton(text: "High Price", onTap: {}).frame(width: 96, height: 40)
                        PrettyButton(text: "Low Price", onTap: {}).frame(width: 88, height: 40)
                        PrettyButton(text: "Newest", onTap: {}).frame(width: 72, height: 40)
                        PrettyButton(text: "Oldest", onTap: {}).frame(width: 72, height: 40)
                    }.fixedSize()
                }
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
        .highPriorityGesture(DragGesture().updating($dragOffset, body: { (value, _, _) in
            if(value.startLocation.x < 50 && value.translation.width > 100) {
                dismissThisView()
            }
        }))
    }
    
    var backgroundBody: some View {
        Rectangle().ignoresSafeArea().foregroundColor(.white)
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
    return RestaurantMenuView<AuthenticationManagerStub,RestaurantManagerStub, OrderManagerStub>(restaurantId: "1", tappedItem: $tapped)
        .environmentObject(RestaurantManagerStub())
        .environmentObject(AuthenticationManagerStub())
        .environmentObject(OrderManagerStub())
}
