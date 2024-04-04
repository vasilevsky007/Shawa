//
//  MenuItemView.swift
//  Shawa
//
//  Created by Alex on 10.04.23.
//

import SwiftUI

struct MenuItemView: View {
    let thisItem: MenuItem
    let restaurant: Restaurant
    let addToCart: (Order.Item) -> Void
    @State private var thisOrderItem: Order.Item
    
    @Environment(\.dismiss) private var dismiss
    
    init(_ menuItem: MenuItem,belongsTo restaurant: Restaurant, addToCart: @escaping (Order.Item) -> Void) {
        thisItem = menuItem
        var additions = [String : Int]()
        for ingredient in restaurant.ingredients {
            additions.updateValue(0, forKey: ingredient.id)
        }
        _thisOrderItem = State(initialValue: Order.Item(menuItem: menuItem, availibleAdditions: restaurant.ingredients))
        self.addToCart = addToCart
        self.restaurant = restaurant
    }
    
    private struct DrawingConstants {
        static let allPadding: CGFloat = 2
        static let additionalPadding: CGFloat = 16
        static let headerSize: CGFloat = 32
        static let subheaderSize: CGFloat = 24
        static let fontSize: CGFloat = 16
        static let ingredientsGridSpacing: CGFloat = 8
        
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader { geometry in
                Rectangle()
                    .foregroundColor(.white)
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        let imageSize = geometry.size.width
                        if let imageUrl = thisItem.image {
                            AsyncImage(url: imageUrl) { image in
                                image
                                    .fillWithoutStretch()
                                    .frame(width: imageSize, alignment: .center)
                            } placeholder: {
                                ProgressView()
                                    .font(.system(size: 64))
                                    .foregroundColor(.gray)
                                    .frame(width: imageSize, height: imageSize / 2)
                            }
                        } else {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 64))
                                .foregroundColor(.gray)
                                .frame(width: imageSize, height: imageSize / 2)
                        }
                        HStack(alignment: .center, spacing: 0) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(thisItem.name)
                                    .font(.main(size: DrawingConstants.headerSize))
                                    .foregroundColor(.deafultBrown)
                                    .padding(.all, DrawingConstants.allPadding)
                                    .padding([.leading, .top, .trailing], DrawingConstants.additionalPadding)
                                Text(
                                    "\(String(format: "%.2f", thisItem.price))"
                                    + ((thisOrderItem.price - thisItem.price) == 0.0 ? " BYN" :
                                        "\(String(format: "%+.2f", thisOrderItem.price - thisItem.price)) BYN")
                                )
                                .font(.mainBold(size: DrawingConstants.subheaderSize))
                                .foregroundColor(.deafultBrown)
                                .padding([.horizontal, .top], DrawingConstants.allPadding)
                                .padding([.leading, .bottom, .trailing], DrawingConstants.additionalPadding)
                            }
                            
                            Spacer(minLength: 0)
                            PrettyButton(text: "Add to cart",systemImage: "cart.badge.plus", fontsize: 16, isActive: true) {
                                addToCart(thisOrderItem)
                            }.frame(width: 120, height:60).padding(.trailing, 10)
                        }
                        
                        LazyVGrid(columns: [.init(.adaptive(minimum: 100), spacing: DrawingConstants.ingredientsGridSpacing, alignment: .center)], alignment: .center, spacing: DrawingConstants.ingredientsGridSpacing) {
                            ForEach(thisItem.ingredientIDs.sorted(), id: \.self) { ingredientId in
                                ingredientTagBox(id: ingredientId)
                            }
                        }
                        .padding(.all, DrawingConstants.allPadding)
                        .padding([.leading, .bottom, .trailing], DrawingConstants.additionalPadding)
                        Text(thisItem.description)
                            .font(.main(size: MenuItemView.DrawingConstants.fontSize))
                            .foregroundColor(.deafultBrown)
                            .padding(.all, DrawingConstants.allPadding)
                            .padding([.leading, .bottom, .trailing], DrawingConstants.additionalPadding)
                        //FIXME: no ingredient items                        if (thisItem.belogsTo != .Drinks) {
                        ingredientsAdder
                            .padding(.all, DrawingConstants.allPadding)
                            .padding(.horizontal, DrawingConstants.additionalPadding)
                        //                        }
                    }
                }
                
            }
        }
        .overlay(alignment: .topTrailing) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 40))
                    .foregroundColor(.lighterBrown)
                    .padding(.all)
            }
        }
    }
    @ViewBuilder
    func ingredientTagBox(id: String) -> some View {
        if let ingredient = restaurant.ingredients.first(where: {$0.id == id}) {
            ZStack(alignment: .center) {
                Capsule()
                    .stroke(lineWidth: 2)
                    .foregroundColor(.primaryBrown)
                
                Text (ingredient.name)
                    .font(.main(size: MenuItemView.DrawingConstants.fontSize))
                    .foregroundColor(.lightBrown)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 2)
            }
            .frame(minHeight: MenuItemView.DrawingConstants.headerSize)
        }
    }
    
    var ingredientsAdder: some View {
        VStack (alignment: .leading) {
            Text("Add ingredients")
                .font(.main(size: DrawingConstants.subheaderSize))
                .foregroundColor(.lightBrown)
            ForEach(restaurant.ingredients) { ingredient in
                HStack {
                    Text((
                        thisOrderItem.additions[ingredient.id]! > -1 ? String(thisOrderItem.additions[ingredient.id]!) : "No"
                    ))
                    .font(.main(size: MenuItemView.DrawingConstants.fontSize))
                    .foregroundColor(.lightBrown)
                    .frame(width: 22)
                    Stepper {
                        Text(ingredient.name.lowercased())
                            .font(.main(size: MenuItemView.DrawingConstants.fontSize))
                            .foregroundColor(.lightBrown)
                    } onIncrement: {
                        if (thisOrderItem.additions[ingredient.id]!.advanced(by: 1) != 101) {
                            thisOrderItem.addOneIngredient(ingredient)
                        }
                        
                    } onDecrement: {
                        if (thisOrderItem.additions[ingredient.id]!.advanced(by: -1) != -2) {
                            thisOrderItem.removeOneIngredient(ingredient)
                        }
                    }
                }
            }
        }
    }
}

struct MenuItemView_Previews: PreviewProvider {
    
    static var previews: some View {
        @ObservedObject var restm = RestaurantManagerStub()
        @State var item: MenuItem? = RestaurantManagerStub().allMenuItems.first!
        Color.red
            .ignoresSafeArea()
            .popover(item: $item) { item in
                if #available(iOS 16.0, *) {
                    MenuItemView(item, belongsTo: restm.restaurants.value!.first!) { addeditem in
                        print(addeditem)
                    }
                    .presentationDetents([.extraLarge])
                } else {
                    MenuItemView(item, belongsTo: restm.restaurants.value!.first!) { addeditem in
                        print(addeditem)
                    }
                }
            }
        
    }
}
