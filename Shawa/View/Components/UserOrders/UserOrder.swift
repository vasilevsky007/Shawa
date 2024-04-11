//
//  Order.swift
//  Shawa
//
//  Created by Alex on 17.11.23.
//

import SwiftUI

struct UserOrder<RestaurantManagerType: RestaurantManager>: View {
    @EnvironmentObject var restaurantManager: RestaurantManagerType
    
    var order: Order
    
    private let headlineFontSize: CGFloat = 24
    
    var timeBody: some View {
        HStack(spacing: 0){
            Spacer()
            if let timestamp = order.timestamp {
                Text(order.timestamp!, style: .date)
                    .padding(.trailing, .Constants.standardSpacing)
                    .foregroundColor(.lighterBrown)
                    .font(.main(size: 16))
                Text(order.timestamp!, style: .time)
                    .foregroundColor(.lighterBrown)
                    .font(.main(size: 16))
            }
        }
    }
    
    var itemsBody: some View {
        ForEach(order.orderItems.keys.sorted(by: { $0.id < $1.id })) { item in
            OrderItemUnchangable<RestaurantManagerType>(item, count: order.orderItems[item]!)
        }
    }
    
    @ViewBuilder var priceBody: some View {
        Divider().overlay(Color.lighterBrown)
        HStack(alignment: .center, spacing: 0) {
            Text("Grand total:")
                .foregroundColor(.deafultBrown)
                .font(.montserratBold(size: headlineFontSize))
                .padding(.trailing, .Constants.standardSpacing)
            Spacer(minLength: 0)
            Text(String(format: "%.2f BYN", order.totalPrice))
                .foregroundColor(.deafultBrown)
                .font(.interBold(size: 20))
                .frame(width: .Constants.UserOrder.priceWidth, alignment: .trailing)
        }
    }
    
    @ViewBuilder var addressBody: some View {
        Divider().overlay(Color.lighterBrown)
        Text("Address:")
            .foregroundColor(.deafultBrown)
            .font(.montserratBold(size: headlineFontSize))
            .padding(.trailing, .Constants.standardSpacing)
        if let street = order.user.address.street {
            VStack {
                Text("Street")
                    .foregroundColor(.deafultBrown)
                    .font(.mainBold(size: 16))
            }
            VStack {
                Text(street)
                    .foregroundColor(.deafultBrown)
                    .font(.main(size: 16))
            }
        }
        if let house = order.user.address.house {
            VStack {
                Text("House")
                    .foregroundColor(.deafultBrown)
                    .font(.mainBold(size: 16))
            }
            VStack {
                Text(house)
                    .foregroundColor(.deafultBrown)
                    .font(.main(size: 16))
            }
        }
        if let apartament = order.user.address.apartament {
            VStack {
                Text("Apartament")
                    .foregroundColor(.deafultBrown)
                    .font(.mainBold(size: 16))
            }
            VStack {
                Text(apartament)
                    .foregroundColor(.deafultBrown)
                    .font(.main(size: 16))
            }
        }
        
    }
    
    @ViewBuilder var commentBody: some View {
        if let comment = order.comment {
            Divider().overlay(Color.lighterBrown)
            HStack(alignment: .center, spacing: 0) {
                Text("Comment:")
                    .foregroundColor(.deafultBrown)
                    .font(.montserratBold(size: headlineFontSize))
                    .padding(.trailing, .Constants.standardSpacing)
                Spacer(minLength: 0)
            }
            Text(comment)
                .foregroundColor(.deafultBrown)
                .font(.main(size: 16))
        }
    }
    
    var body: some View {
        LazyVStack (alignment: .leading, spacing: .Constants.doubleSpacing) {
            timeBody
            itemsBody
            addressBody
            commentBody
            priceBody
        }
        .padding(.all, .Constants.standardSpacing)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: .Constants.UserOrder.cornerRadius)
                    .fill(Color.veryLightBrown)
                RoundedRectangle(cornerRadius: .Constants.UserOrder.cornerRadius)
                    .stroke(Color.deafultBrown, lineWidth: .Constants.doubleBorderWidth)
            }
        }
    }
}

#Preview {
    @ObservedObject var rm = RestaurantManagerStub()
    var o = Order()
    o.addOneOrderItem(.init(menuItem: rm.allMenuItems.first!, availibleAdditions: rm.restaurants.value!.first!.ingredients))
    o.updateAddress(street: "str Asd", house: "h 8", apartament: "ap 12")
    o.updateComment("order comment xddd")
    o.addTimestamp(date: .now)
    o.addOneIngredient(rm.restaurants.value!.first!.ingredients.first!, to: o.orderItems.first!.key)
    return UserOrder<RestaurantManagerStub>(order: o)
        .padding()
        .environmentObject(rm)
}
