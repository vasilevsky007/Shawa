//
//  OrderItemUnchangable.swift
//  Shawa
//
//  Created by Alex on 17.11.23.
//

import SwiftUI

struct OrderItemUnchangable<RestaurantManagerType: RestaurantManager>: View {
    @EnvironmentObject private var restaurantManager: RestaurantManagerType
    
    let thisItem: Order.Item
    let thisItemCount: Int
    
    private let headerFontSize: CGFloat = 20
    private let fontSize: CGFloat = 16
    
    private var thisMenuItem: MenuItem? {
        restaurantManager.menuItem(withId: thisItem.itemID)
    }
    
    init(_ thisItem: Order.Item, count: Int) {
        self.thisItem = thisItem
        self.thisItemCount = count
    }
    
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: .Constants.elementCornerRadius)
                .strokeBorder(lineWidth: 1)
                .foregroundColor(.lighterBrown)
            VStack(alignment: .trailing, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    if let imageUrl = thisMenuItem?.image {
                        LoadableImage(imageUrl: imageUrl)
                            .frame(width: .Constants.OrderItemUnchangable.imageSize, height: .Constants.OrderItemUnchangable.imageSize)
                            .cornerRadius(.Constants.elementCornerRadius)
                            .padding([.trailing, .bottom], .Constants.standardSpacing)
                    } else {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: .Constants.OrderItemUnchangable.imageSize))
                            .foregroundColor(.gray)
                            .frame(width: .Constants.OrderItemUnchangable.imageSize, height: .Constants.OrderItemUnchangable.imageSize)
                            .cornerRadius(.Constants.elementCornerRadius)
                            .padding([.trailing, .bottom], .Constants.standardSpacing)
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(thisMenuItem?.name ?? "Item not found in current menu")
                                    .font(.main(size: headerFontSize))
                                    .foregroundColor(.deafultBrown)
                                    .padding(.top, .Constants.standardSpacing)
                                if let price = thisMenuItem?.price {
                                    Text(String(format: "%.2f", price) + " BYN")
                                        .font(.mainBold(size: fontSize))
                                        .foregroundColor(.deafultBrown)
                                }
                            }
                            Spacer(minLength: 0)

                        }
                        
                        ForEach(thisItem.additions.keys.sorted(), id: \.self) { additionID in
                            VStack(alignment: .trailing, spacing: 0) {
                                Text(ingredientNameAndCountLocalized(id: additionID))
                                .font(.main(size: fontSize))
                                .foregroundColor(.deafultBrown)
                                
                                Text(ingredientCostLocalized(id: additionID))
                                .font(.main(size: fontSize))
                                .foregroundColor(.deafultBrown)
                            }
                        }
                        Divider()
                            .overlay{ Color.primaryBrown }
                            .padding(.top, .Constants.standardSpacing)

                    }
                }.padding(.all, .Constants.standardSpacing)
                HStack(spacing: 0) {
                    Text(String(format: "%d x %.2f BYN", thisItemCount, thisItem.price))
                        .font(.interBold(size: fontSize))
                    .foregroundColor(.deafultBrown)
                }
                .padding([.bottom, .horizontal], .Constants.standardSpacing)

            }

        }
    }
    
    func ingredientNameAndCountLocalized(id ingredientId: String) -> LocalizedStringKey {
        "+ \(thisItem.additions[ingredientId]! > 0 ? String(thisItem.additions[ingredientId]!) + " x " : "No ") \(restaurantManager.ingredient(withId: ingredientId)?.name ?? "Ingredient not found in current menu")"
    }
    
    func ingredientCostLocalized(id ingredientId: String) -> LocalizedStringKey {
        "\(String(format: "+%.2f", Double(thisItem.additions[ingredientId]! > 0 ? thisItem.additions[ingredientId]! : 0) * (restaurantManager.ingredient(withId: ingredientId)?.cost ?? 0))) BYN"
    }
}

#Preview {
    @ObservedObject var rm = RestaurantManagerStub()
    return OrderItemUnchangable<RestaurantManagerStub>(
        .init(
            menuItem: rm.allMenuItems.first!,
            availibleAdditions: rm.restaurants.value!.first!.ingredients),
        count: 1)
    .frame(height: .Constants.OrderItemUnchangable.imageSize + .Constants.doubleSpacing)
    .padding()
    .environmentObject(rm)
}
