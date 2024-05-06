//
//  Order.swift
//  Shawa
//
//  Created by Alex on 17.11.23.
//

import SwiftUI

struct UserOrder<RestaurantManagerType: RestaurantManager, OrderManagerType: OrderManager>: View {
    @EnvironmentObject var restaurantManager: RestaurantManagerType
    @EnvironmentObject var orderManager: OrderManagerType
    
    var isAdmin: Bool = false
    var order: Order
    
    private let headlineFontSize: CGFloat = 24
    
    var timeBody: some View {
        HStack(spacing: 0){
            Spacer()
            if let timestamp = order.timestamp {
                Text(timestamp, style: .date)
                    .padding(.trailing, .Constants.standardSpacing)
                    .foregroundColor(.lighterBrown)
                    .font(.main(size: 16))
                Text(timestamp, style: .time)
                    .foregroundColor(.lighterBrown)
                    .font(.main(size: 16))
            }
        }
    }
    
    var itemsBody: some View {
        ForEach(order.orderItems.keys.sorted(by: { $0.id < $1.id })) { item in
            OrderItemUnchangable<RestaurantManagerType>(
                item,
                count: order.orderItems[item]!,
                isAdmin: isAdmin
            )
        }
    }
    
    @ViewBuilder var priceBody: some View {
        Divider().overlay(Color.lighterBrown)
        HStack(alignment: .center, spacing: 0) {
            Text("Grand total:")
                .foregroundColor(.defaultBrown)
                .font(.montserratBold(size: headlineFontSize))
                .padding(.trailing, .Constants.standardSpacing)
            Spacer(minLength: 0)
            Text(String(format: "%.2f BYN", order.totalPrice))
                .foregroundColor(.defaultBrown)
                .font(.interBold(size: 20))
                .frame(width: .Constants.UserOrder.priceWidth, alignment: .trailing)
        }
    }
    
    @ViewBuilder var addressBody: some View {
        Divider().overlay(Color.lighterBrown)
        Text("Address:")
            .foregroundColor(.defaultBrown)
            .font(.montserratBold(size: headlineFontSize))
            .padding(.trailing, .Constants.standardSpacing)
        if let street = order.user.address.street {
            VStack {
                Text("Street")
                    .foregroundColor(.defaultBrown)
                    .font(.mainBold(size: 16))
            }
            VStack {
                Text(street)
                    .foregroundColor(.defaultBrown)
                    .font(.main(size: 16))
            }
        }
        if let house = order.user.address.house {
            VStack {
                Text("House")
                    .foregroundColor(.defaultBrown)
                    .font(.mainBold(size: 16))
            }
            VStack {
                Text(house)
                    .foregroundColor(.defaultBrown)
                    .font(.main(size: 16))
            }
        }
        if let apartament = order.user.address.apartament {
            VStack {
                Text("Apartament")
                    .foregroundColor(.defaultBrown)
                    .font(.mainBold(size: 16))
            }
            VStack {
                Text(apartament)
                    .foregroundColor(.defaultBrown)
                    .font(.main(size: 16))
            }
        }
        
    }
    
    @ViewBuilder var commentBody: some View {
        if let comment = order.comment {
            Divider().overlay(Color.lighterBrown)
            HStack(alignment: .center, spacing: 0) {
                Text("Comment:")
                    .foregroundColor(.defaultBrown)
                    .font(.montserratBold(size: headlineFontSize))
                    .padding(.trailing, .Constants.standardSpacing)
                Spacer(minLength: 0)
            }
            Text(comment)
                .foregroundColor(.defaultBrown)
                .font(.main(size: 16))
        }
    }
    
    @ViewBuilder var statusBody: some View {
            Divider().overlay(Color.lighterBrown)
            HStack(alignment: .center, spacing: 0) {
                Text("Order status:")
                    .foregroundColor(.defaultBrown)
                    .font(.montserratBold(size: headlineFontSize))
                    .padding(.trailing, .Constants.standardSpacing)
                Spacer(minLength: 0)
            }
        SegmentedProgressBar(
            currentState: order.state ,
            allCases: order.state == .cancelled ? [.sended,.confirmed,.cancelled] : [.sended, .confirmed, .delivering, .delivered],
            activeColor: order.state == .cancelled ? .red : .primaryBrown) { tappedCase in
                if isAdmin {
                    Task {
                        try await orderManager.updateOrderState(to: tappedCase, in: order)
                    }
                }
            }
            
            Text(LocalizedStringKey(order.state?.description ?? "Error"))
                .foregroundColor(.defaultBrown)
                .font(.main(size: 16))
    }
    
    var body: some View {
        LazyVStack (alignment: .leading, spacing: .Constants.doubleSpacing) {
            timeBody
            itemsBody
            addressBody
            commentBody
            statusBody
            priceBody
        }
        .padding(.all, .Constants.standardSpacing)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: .Constants.UserOrder.cornerRadius)
                    .fill(isAdmin ? Color.clear : Color.veryLightBrown)
                RoundedRectangle(cornerRadius: .Constants.UserOrder.cornerRadius)
                    .stroke(Color.defaultBrown, lineWidth: .Constants.doubleBorderWidth)
            }
        }
    }
}

#Preview {
    @ObservedObject var rm = RestaurantManagerStub()
    @ObservedObject var om = OrderManagerStub()
    var o = Order()
    o.addOneOrderItem(.init(menuItem: rm.allMenuItems.first!, availibleAdditions: rm.restaurants.value!.first!.ingredients))
    o.updateAddress(street: "str Asd", house: "h 8", apartament: "ap 12")
    o.updateComment("order comment xddd")
    o.addTimestamp(date: .now)
    o.addOneIngredient(rm.restaurants.value!.first!.ingredients.first!, to: o.orderItems.first!.key)
    o.updateState(.delivering)
    return UserOrder<RestaurantManagerStub, OrderManagerStub>(order: o)
        .padding()
        .environmentObject(rm)
        .environmentObject(om)
}
