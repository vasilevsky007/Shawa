//
//  OrderItem.swift
//  Shawa
//
//  Created by Alex on 12.08.23.
//

import SwiftUI


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
    
    private let mainFontSize: CGFloat = 16
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: .Constants.elementCornerRadius)
                .strokeBorder(lineWidth: 1)
                .foregroundColor(.lighterBrown)
            VStack(alignment: .trailing, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    LoadableImage(imageUrl: menuItem.image)
                        .frame(width: .Constants.OrderItem.imageSize, height: .Constants.OrderItem.imageSize, alignment: .center)
                        .cornerRadius(.Constants.elementCornerRadius)
                        .padding([.trailing, .bottom], .Constants.standardSpacing)
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(menuItem.name)
                                    .font(.main(size: 20))
                                    .foregroundColor(.deafultBrown)
                                    .padding(.top, .Constants.standardSpacing)
                                Text(String(format: "%.2f", menuItem.price) + " BYN")
                                    .font(.mainBold(size: mainFontSize))
                                    .foregroundColor(.deafultBrown)
                            }
                            Spacer(minLength: 0)
                            Button(role: .destructive) {
                                orderManager.removeOrderItem(thisItem)
                            } label: {
                                Image(systemName: "trash")
                                    .font(.main(size: .Constants.OrderItem.deleteIconSize))
                            }.padding(.trailing, .Constants.doubleSpacing)

                        }
                        
                        ForEach(thisItem.additions.keys.sorted(), id: \.self) { additionID in
                            if let addition =  restaurantManager.ingredient(withId: additionID) {
                                if thisItem.additions[additionID] ?? 0 != 0 {
                                    VStack(alignment: .trailing, spacing: 0) {
                                        ZStack (alignment: .leading) {
                                            Text("+ " + (thisItem.additions[additionID]! > 0 ?
                                                         String(thisItem.additions[additionID]!) + " x "
                                                         : "No ")
                                                 + addition.name)
                                            .font(.main(size: mainFontSize))
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
                                        .font(.main(size: mainFontSize))
                                        .foregroundColor(.deafultBrown)
                                    }
                                }
                            }
                        }
                        
                        Divider()
                            .overlay{ Color.primaryBrown }
                            .padding(.top, .Constants.standardSpacing)

                    }
                }.padding(.all, .Constants.standardSpacing)
                HStack(spacing: 0) {
                    Stepper {
                        Spacer(minLength: 0)
                    } onIncrement: {
                        orderManager.addOneOrderItem(thisItem)
                    } onDecrement: {
                        orderManager.removeOneOrderItem(thisItem)
                    }
                    Spacer(minLength: .Constants.standardSpacing)
                    Text(String(format: "%d x %.2f BYN", numberOfCurrentItems, thisItem.price))
                        .font(.interBold(size: mainFontSize))
                    .foregroundColor(.deafultBrown)
                }
                .padding([.bottom, .horizontal], .Constants.standardSpacing)

            }

        }
        //.frame(height: .Constants.OrderItem.imageSize + .Constants.OrderItem.padding * 2)
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
