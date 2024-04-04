//
//  OrderItem.swift
//  Shawa
//
//  Created by Alex on 12.0DrawingConstants.padding.23.
//

import SwiftUI

fileprivate struct DrawingConstants {
    static let cornerRadius: CGFloat = 10
    static let padding: CGFloat = 8
    static let imageSize: CGFloat = 96
    static let headerFontSize: CGFloat = 20
    static let fontSize: CGFloat = 16
}

struct OrderItem<RestaurantManagerType: RestaurantManager, OrderManagerType: OrderManager>: View {
    @State private var thisItem: Order.Item
    
    @EnvironmentObject private var restaurantManager: RestaurantManagerType
    @EnvironmentObject private var orderManager: OrderManagerType
    
    init(_ thisItem: Order.Item) {
        self.thisItem = thisItem
    }
    
    var menuItem: MenuItem {
        restaurantManager.menuItem(withId: thisItem.itemID)!
    }
    
    var numberOfCurrentItems: Int {
        orderManager.currentOrder.orderItems[thisItem] ?? 0
    }

    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                .strokeBorder(lineWidth: 1)
                .foregroundColor(.lighterBrown)
            VStack(alignment: .trailing, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    LoadableImage(imageUrl: menuItem.image)
                        .frame(width: DrawingConstants.imageSize, height: DrawingConstants.imageSize, alignment: .center)
                        .cornerRadius(DrawingConstants.cornerRadius)
                        .padding([.trailing, .bottom], DrawingConstants.padding)
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(menuItem.name)
                                    .font(.main(size: DrawingConstants.headerFontSize))
                                    .foregroundColor(.deafultBrown)
                                    .padding(.top, DrawingConstants.padding)
                                Text(String(format: "%.2f", menuItem.price) + " BYN")
                                    .font(.mainBold(size: DrawingConstants.fontSize))
                                    .foregroundColor(.deafultBrown)
                            }
                            Spacer(minLength: 0)
                            Button(role: .destructive) {
                                orderManager.removeOrderItem(thisItem)
                            } label: {
                                Image(systemName: "trash")
                                    .font(.main(size: 32))
                            }.padding(.trailing, 16)

                        }
//??
                        
                        ForEach(thisItem.additions.keys.sorted(), id: \.self) { additionID in
                            if let addition =  restaurantManager.ingredient(withId: additionID) {
                                if thisItem.additions[additionID] ?? 0 != 0 {
                                    VStack(alignment: .trailing, spacing: 0) {
                                        ZStack (alignment: .leading) {
                                            Text("+ " + (thisItem.additions[additionID]! > 0 ?
                                                         String(thisItem.additions[additionID]!) + " x "
                                                         : "No ")
                                                 + addition.name)
                                            .font(.main(size: DrawingConstants.fontSize))
                                            .foregroundColor(.deafultBrown)
                                            Spacer()
                                            Stepper {
                                                
                                            } onIncrement: {
                                                orderManager.addOneIngredient(addition, to: thisItem)
                                                thisItem.addOneIngredient(addition)
                                            } onDecrement: {
                                                orderManager.removeOneIngredient(addition, from: thisItem)
                                                thisItem.removeOneIngredient(addition)
                                            }
                                            .scaleEffect(0.7, anchor: .trailing)
                                        }
                                        Text("+" + (thisItem.additions[additionID]! > 0 ?
                                                    String(format: "%.2f", Double(thisItem.additions[additionID]!) * addition.cost)
                                                    : "0")
                                             + " BYN")
                                        .font(.main(size: DrawingConstants.fontSize))
                                        .foregroundColor(.deafultBrown)
                                    }
                                }
                            }
                        }
                        
//                        ??
                        Divider()
                            .overlay{ Color.primaryBrown }
                            .padding(.top, DrawingConstants.padding)

                    }
                }.padding(.all, DrawingConstants.padding)
                HStack(spacing: 0) {
                    Stepper {
                        Spacer(minLength: 0)
                    } onIncrement: {
                        orderManager.addOneOrderItem(thisItem)
                    } onDecrement: {
                        orderManager.removeOneOrderItem(thisItem)
                    }
                    Spacer(minLength: DrawingConstants.padding)
                    Text(String(format: "%d x %.2f BYN", numberOfCurrentItems, thisItem.price))
                        .font(.interBold(size: DrawingConstants.fontSize))
                    .foregroundColor(.deafultBrown)
                }
                .padding([.bottom, .horizontal], DrawingConstants.padding)

            }

        }
        //.frame(height: DrawingConstants.imageSize + DrawingConstants.padding * 2)
    }
    
}

#Preview {
    @ObservedObject var om = OrderManagerStub()
    @ObservedObject var rm = RestaurantManagerStub()
    om.addOneOrderItem(Order.Item(menuItem: rm.allMenuItems.first!, availibleAdditions: rm.restaurants.value!.first!.ingredients))
    return OrderItem<RestaurantManagerStub, OrderManagerStub>(om.currentOrder.orderItems.keys.first!)
        .environmentObject(om)
        .environmentObject(rm)
}
