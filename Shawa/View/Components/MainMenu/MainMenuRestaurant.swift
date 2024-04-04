//
//  MainMenuRestaurant.swift
//  Shawa
//
//  Created by Alex on 12.03.23.
//

import SwiftUI

struct MainMenuRestaurant: View {
    var restaurant: Restaurant
    @Binding var tappedItem: MenuItem?
    var body: some View {
        VStack{
            HStack{
                Text(restaurant.name)
                    .font(.main(size: 16))
                    .foregroundColor(.deafultBrown)
                Spacer()
                Text("See All")
                    .foregroundColor(.lightBrown)
                    .font(.main(size: 14))

            }
            if #available(iOS 17.0, *) {
                ScrollView(Axis.Set.horizontal, showsIndicators: false) {
                    itemStack.scrollTargetLayout()
                }.scrollTargetBehavior(.viewAligned)
            } else {
                ScrollView(Axis.Set.horizontal, showsIndicators: false) {
                    itemStack
                }
            }
        }
    }
    
    var itemStack: some View {
        LazyHStack{
            ForEach(restaurant.menu.sorted(by: { $0.popularity > $1.popularity }).prefix(5)) { menuItem in
                Button {
                    tappedItem = menuItem
                } label: {
                    MenuItemCard(menuItem)
                        .frame(width: 155, height: 215)
                        .padding(.trailing, 8)
                }
            }
        }
    }
}

#Preview {
    @State var tapped: MenuItem? = nil
    return MainMenuRestaurant(restaurant: RestaurantManagerStub().restaurants.value!.first!, tappedItem: $tapped)
}
