//
//  OrderItemUnchangable.swift
//  Shawa
//
//  Created by Alex on 17.11.23.
//

import SwiftUI

fileprivate struct DrawingConstants {
    static let cornerRadius: CGFloat = 10
    static let padding: CGFloat = 8
    static let imageSize: CGFloat = 96
    static let headerFontSize: CGFloat = 20
    static let fontSize: CGFloat = 16
}

struct OrderItemUnchangable<RestaurantManagerType: RestaurantManager>: View {
    @EnvironmentObject private var restaurantManager: RestaurantManagerType
    
    let thisItem: Order.Item
    let thisItemCount: Int
    
    private var thisMenuItem: MenuItem? {
        restaurantManager.menuItem(withId: thisItem.itemID)
    }
    
    init(_ thisItem: Order.Item, count: Int) {
        self.thisItem = thisItem
        self.thisItemCount = count
    }
    
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                .strokeBorder(lineWidth: 1)
                .foregroundColor(.lighterBrown)
            VStack(alignment: .trailing, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    if let imageUrl = thisMenuItem?.image {
                        LoadableImage(imageUrl: imageUrl)
                            .frame(width: DrawingConstants.imageSize, height: DrawingConstants.imageSize)
                            .cornerRadius(DrawingConstants.cornerRadius)
                            .padding([.trailing, .bottom], DrawingConstants.padding)
                    } else {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: DrawingConstants.imageSize))
                            .foregroundColor(.gray)
                            .frame(width: DrawingConstants.imageSize, height: DrawingConstants.imageSize)
                            .cornerRadius(DrawingConstants.cornerRadius)
                            .padding([.trailing, .bottom], DrawingConstants.padding)
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(thisMenuItem?.name ?? "Item not found in current menu")
                                    .font(.main(size: DrawingConstants.headerFontSize))
                                    .foregroundColor(.deafultBrown)
                                    .padding(.top, DrawingConstants.padding)
                                if let price = thisMenuItem?.price {
                                    Text(String(format: "%.2f", price) + " BYN")
                                        .font(.mainBold(size: DrawingConstants.fontSize))
                                        .foregroundColor(.deafultBrown)
                                }
                            }
                            Spacer(minLength: 0)

                        }
                        
                        ForEach(thisItem.additions.keys.sorted(), id: \.self) { additionID in
                            VStack(alignment: .trailing, spacing: 0) {
                                Text(ingredientNameAndCountLocalized(id: additionID))
                                .font(.main(size: DrawingConstants.fontSize))
                                .foregroundColor(.deafultBrown)
                                
                                Text(ingredientCostLocalized(id: additionID))
                                .font(.main(size: DrawingConstants.fontSize))
                                .foregroundColor(.deafultBrown)
                            }
                        }
                        Divider()
                            .overlay{ Color.primaryBrown }
                            .padding(.top, DrawingConstants.padding)

                    }
                }.padding(.all, DrawingConstants.padding)
                HStack(spacing: 0) {
                    Text(String(format: "%d x %.2f BYN", thisItemCount, thisItem.price))
                        .font(.interBold(size: DrawingConstants.fontSize))
                    .foregroundColor(.deafultBrown)
                }
                .padding([.bottom, .horizontal], DrawingConstants.padding)

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
    .frame(height: DrawingConstants.imageSize + DrawingConstants.padding * 2)
    .padding()
    .environmentObject(rm)
}
