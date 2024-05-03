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
    
    private let fontSize: CGFloat = 16
    
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
                                    .font(.main(size: 32))
                                    .foregroundColor(.defaultBrown)
                                    .padding([.leading, .top, .trailing], .Constants.doubleSpacing)
                                Text(
                                    "\(String(format: "%.2f", thisItem.price))"
                                    + ((thisOrderItem.price - thisItem.price) == 0.0 ? " BYN" :
                                        "\(String(format: "%+.2f", thisOrderItem.price - thisItem.price)) BYN")
                                )
                                .font(.mainBold(size: 24))
                                .foregroundColor(.defaultBrown)
                                .padding([.leading, .bottom, .trailing], .Constants.doubleSpacing)
                            }
                            
                            Spacer(minLength: 0)
                            PrettyButton(text: "Add to cart",systemImage: "cart.badge.plus", fontsize: 16, isActive: true) {
                                addToCart(thisOrderItem)
                            }
                                .frame(width: .Constants.MenuItemView.addButtonWidth, height:.Constants.MenuItemView.addButtonHeight)
                                .padding(.trailing, .Constants.standardSpacing)
                        }
                        
                        LazyVGrid(columns: [.init(.adaptive(minimum: .Constants.MenuItemView.ingredientBoxMinWidth), spacing: .Constants.standardSpacing, alignment: .center)], alignment: .center, spacing: .Constants.standardSpacing) {
                            ForEach(thisItem.ingredientIDs.sorted(), id: \.self) { ingredientId in
                                ingredientTagBox(id: ingredientId)
                            }
                        }
                        .padding([.leading, .bottom, .trailing], .Constants.doubleSpacing)
                        Text(thisItem.description)
                            .font(.main(size: fontSize))
                            .foregroundColor(.defaultBrown)
                            .padding([.leading, .bottom, .trailing], .Constants.doubleSpacing)
                        //FIXME: no ingredient items                        if (thisItem.belogsTo != .Drinks) {
                        ingredientsAdder
                            .padding(.horizontal, .Constants.doubleSpacing)
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
                    .font(.main(size: fontSize))
                    .foregroundColor(.lightBrown)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 2)
            }
            .frame(minHeight: .Constants.MenuItemView.ingredientBoxHeight)
        }
    }
    
    var ingredientsAdder: some View {
        VStack (alignment: .leading) {
            Text("Add ingredients")
                .font(.main(size: 24))
                .foregroundColor(.lightBrown)
            ForEach(restaurant.ingredients) { ingredient in
                HStack {
                    Text((
                        thisOrderItem.additions[ingredient.id]! > -1 ? String(thisOrderItem.additions[ingredient.id]!) : "No"
                    ))
                    .font(.main(size: fontSize))
                    .foregroundColor(.lightBrown)
                    .frame(width: 22)
                    Stepper {
                        Text(ingredient.name.lowercased())
                            .font(.main(size: fontSize))
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
