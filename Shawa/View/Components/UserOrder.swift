//
//  Order.swift
//  Shawa
//
//  Created by Alex on 17.11.23.
//

import SwiftUI

struct UserOrder: View {
    var order: Order
    
    private struct DrawingConstants {
        static let gridSpacing: CGFloat = 16
        static let padding: CGFloat = 8
        static let cornerRadius: CGFloat = 16
        static let headlineFontSize: CGFloat = 24
    }
    
    var timeBody: some View {
        HStack(spacing: 0){
            Spacer()
            Text(order.timestamp!, style: .date)
                .padding(.trailing, DrawingConstants.padding)
                .foregroundColor(.lighterBrown)
                .font(.main(size: 16))
            Text(order.timestamp!, style: .time)
                .foregroundColor(.lighterBrown)
                .font(.main(size: 16))
        }
    }
    
    var itemsBody: some View {
        ForEach(Array(order.orderItems.keys.sorted(by: { item1, item2 in
            if item1.item.name != item2.item.name {
                return item1.item.name < item2.item.name
            } else {
                return item1.id.description < item2.id.description
            }
        }))) {item in
            OrderItemUnchangable(item, count: order.orderItems[item]!)
        }
    }
    
    @ViewBuilder var priceBody: some View {
        Divider().overlay(Color.lighterBrown)
        HStack(alignment: .center, spacing: 0) {
            Text("Grand total:")
                .foregroundColor(.deafultBrown)
                .font(.montserratBold(size: DrawingConstants.headlineFontSize))
                .padding(.trailing, DrawingConstants.padding)
            Spacer(minLength: 0)
            Text(String(format: "%.2f BYN", order.totalPrice))
                .foregroundColor(.deafultBrown)
                .font(.interBold(size: 20))
                .frame(width: 136, alignment: .trailing)
        }
    }
    
    @ViewBuilder var addressBody: some View {
        Divider().overlay(Color.lighterBrown)
        Text("Address:")
            .foregroundColor(.deafultBrown)
            .font(.montserratBold(size: DrawingConstants.headlineFontSize))
            .padding(.trailing, DrawingConstants.padding)
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
                Text("Street")
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
                Text("Street")
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
                    .font(.montserratBold(size: DrawingConstants.headlineFontSize))
                    .padding(.trailing, DrawingConstants.padding)
                Spacer(minLength: 0)
            }
            Text(comment)
                .foregroundColor(.deafultBrown)
                .font(.main(size: 16))
        }
    }
    
    var body: some View {
        LazyVStack (alignment: .leading, spacing: DrawingConstants.gridSpacing) {
            timeBody
            itemsBody
            addressBody
            commentBody
            priceBody
        }
        .padding(.all, DrawingConstants.padding)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                    .fill(Color.veryLightBrown)
                RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                    .stroke(Color.deafultBrown, lineWidth: 2)
            }
        }
    }
}

#Preview {
    var o = Order()
    o.addOneOrderItem(.init(item: .init(id: 1, belogsTo: .Shawarma, name: "saddq", price: 14.99, dateAdded: .now, popularity: 21, ingredients: Set(), description: "socdcc cdqin cqd cqicdwnxqdc iqcdw c"), additions: [:]))
    o.updateComment("order comment xddd")
    o.addTimestamp(date: .now)
    return UserOrder(order: o)
}
