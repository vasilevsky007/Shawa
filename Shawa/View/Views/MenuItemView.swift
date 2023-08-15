//
//  MenuItemView.swift
//  Shawa
//
//  Created by Alex on 10.04.23.
//

import SwiftUI

struct MenuItemView: View {
    let thisItem: Menu.Item
    let addToCart: (Order.Item) -> Void
    @State var thisOrderItem: Order.Item
    
    @Environment(\.dismiss) private var dismiss
    
    init(_ item: Menu.Item, addToCart: @escaping (Order.Item) -> Void) {
        thisItem = item
        var additions: [Menu.Ingredient:Int] = [:]
        for ingredient in Menu.Ingredient.allCases {
            additions.updateValue(0, forKey: ingredient)
        }
        _thisOrderItem = State(initialValue: Order.Item.init(item: item, additions: additions))
        self.addToCart = addToCart
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
                        if let imageData = thisItem.image {
                            if let uiImage = UIImage(data: imageData){
                                Image(uiImage: uiImage)
                                    .resizable(resizingMode: .stretch)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: imageSize)
                            } else {
                                Image(systemName: "exclamationmark.triangle")
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
                                Text(String(format: "%.2f", thisItem.price) + " BYN")
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
                            ForEach(thisItem.ingredients.sorted(by: { $0.rawValue > $1.rawValue }), id: \.self) { ingredient in
                                ingredientTagBox(ingredient)
                            }
                        }
                            .padding(.all, DrawingConstants.allPadding)
                            .padding([.leading, .bottom, .trailing], DrawingConstants.additionalPadding)
                        Text(thisItem.description)
                            .font(.main(size: MenuItemView.DrawingConstants.fontSize))
                            .foregroundColor(.deafultBrown)
                            .padding(.all, DrawingConstants.allPadding)
                            .padding([.leading, .bottom, .trailing], DrawingConstants.additionalPadding)
                        if (thisItem.belogsTo != .Drinks) {
                            ingredientsAdder
                                .padding(.all, DrawingConstants.allPadding)
                                .padding(.horizontal, DrawingConstants.additionalPadding)
                        }
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
    
    func ingredientTagBox(_ ingredient: Menu.Ingredient) -> some View {
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
    
    var ingredientsAdder: some View {
        @State var a = 0.4
        return VStack (alignment: .leading) {
            Text("Add ingredients")
                .font(.main(size: DrawingConstants.subheaderSize))
                .foregroundColor(.lightBrown)
            ForEach(Menu.Ingredient.allCases, id: \.self) { ingredient in
                HStack {
                    Text((
                        thisOrderItem.additions[ingredient]! > -1 ? String(thisOrderItem.additions[ingredient]!) : "No"
                    ))
                        .font(.main(size: MenuItemView.DrawingConstants.fontSize))
                        .foregroundColor(.lightBrown)
                        .frame(width: 22)
                    Stepper {
                        Text(ingredient.name.lowercased())
                            .font(.main(size: MenuItemView.DrawingConstants.fontSize))
                            .foregroundColor(.lightBrown)
                    } onIncrement: {
                        if (thisOrderItem.additions[ingredient]!.advanced(by: 1) != 101) {
                            thisOrderItem.id = UUID()
                            thisOrderItem.additions.updateValue(
                                thisOrderItem.additions[ingredient]!.advanced(by: 1),
                                forKey: ingredient)
                        }
                        
                    } onDecrement: {
                        if (thisOrderItem.additions[ingredient]!.advanced(by: -1) != -2) {
                            thisOrderItem.id = UUID()
                            thisOrderItem.additions.updateValue(
                                thisOrderItem.additions[ingredient]!.advanced(by: -1),
                                forKey: ingredient)
                        }
                    }
                }
            }
        }
    }
}




struct MenuItemView_Previews: PreviewProvider {
    
    static var previews: some View {
        @State var ab: Menu.Item? = Menu.Item(id: 1, belogsTo: .Shawarma, name: "Shawa1", price: 8.99, image: UIImage(named: "ShawarmaPicture")!.pngData()!, dateAdded: Date(), popularity: 2, ingredients: [.Cheese, .Chiken, .Onion, .HalapenyoPepper, .PickledCucumbers], description: "jfehlka s;dladc iweq j;kdls'dc iwqf hldj;k'l,fd jfehlkas;d ladc iweqj;kdls'dc iwqj;k'l,fd jfeh lkas;d ladc iweq j;k dlfjkd s'dc iwqfh ldj;k 'l,fd jfe hlkas;dl adc iweqj ;kdls'dc iwq fhldj ;k'l, fd")
        Color.red
            .ignoresSafeArea()
            .popover(item: $ab) { item in
                MenuItemView(item) { addeditem in
                    print(addeditem)
                }
//                    .presentationCompactAdaptation()
            }
            
    }
}
