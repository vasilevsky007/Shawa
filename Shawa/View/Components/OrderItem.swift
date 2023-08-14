//
//  OrderItem.swift
//  Shawa
//
//  Created by Alex on 12.0DrawingConstants.padding.23.
//

import SwiftUI

struct OrderItem: View {
    let thisItem: Order.Item
    let addOneIngredient: (_ ingredient: Menu.Ingredient, _ item: Order.Item) -> Void
    let removeOneIngredient: (_ ingredient: Menu.Ingredient, _ item: Order.Item) -> Void
    
    init(_ thisItem: Order.Item,
         addOneIngredient: @escaping (_ ingredient: Menu.Ingredient, _ item: Order.Item) -> Void,
         removeOneIngredient: @escaping (_ ingredient: Menu.Ingredient, _ item: Order.Item) -> Void) {
        self.thisItem = thisItem
        self.addOneIngredient = addOneIngredient
        self.removeOneIngredient = removeOneIngredient
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let padding: CGFloat = 8
        static let imageSize: CGFloat = 96
        static let headerFontSize: CGFloat = 20
        static let fontSize: CGFloat = 16
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                .strokeBorder(lineWidth: 1)
                .foregroundColor(.lighterBrown)
            HStack(alignment: .top) {
                if let imageData = thisItem.item.image {
                    if let uiImage = UIImage(data: imageData){
                        Image(uiImage: uiImage)
                            .resizable(resizingMode: .stretch)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: DrawingConstants.imageSize, height: DrawingConstants.imageSize)
                            .cornerRadius(DrawingConstants.cornerRadius)
                            .padding([.leading, .top, .trailing], DrawingConstants.padding)
                    } else {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: DrawingConstants.imageSize))
                            .foregroundColor(.gray)
                            .frame(width: DrawingConstants.imageSize, height: DrawingConstants.imageSize)
                            .cornerRadius(DrawingConstants.cornerRadius)
                            .padding([.leading, .top, .trailing], DrawingConstants.padding)
                    }
                } else {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: DrawingConstants.imageSize))
                        .foregroundColor(.gray)
                        .frame(width: DrawingConstants.imageSize, height: DrawingConstants.imageSize)
                        .cornerRadius(DrawingConstants.cornerRadius)
                        .padding([.leading, .top, .trailing], DrawingConstants.padding)
                }
                VStack(alignment: .leading) {
                    Text(thisItem.item.name)
                        .font(.main(size: DrawingConstants.headerFontSize))
                        .foregroundColor(.deafultBrown)
                        .padding(.top, DrawingConstants.padding)
                    Text(String(format: "%.2f", thisItem.item.price) + " BYN")
                        .font(.mainBold(size: DrawingConstants.fontSize))
                        .foregroundColor(.deafultBrown)
                    ForEach(thisItem.additions.keys.sorted(by: { a, b in
                        a.name < b.name
                    })) { addition in
                        VStack(alignment: .trailing, spacing: 0) {
                            ZStack (alignment: .leading) {
                                Text("+ " + (thisItem.additions[addition]! > 0 ?
                                             String(thisItem.additions[addition]!) + " x "
                                             : "No ")
                                     + addition.name)
                                .font(.main(size: DrawingConstants.fontSize))
                                .foregroundColor(.deafultBrown)
                                Spacer()
                                Stepper {
                                     
                                } onIncrement: {
                                    addOneIngredient(addition, thisItem)
                                } onDecrement: {
                                    removeOneIngredient(addition, thisItem)
                                }
                                .scaleEffect(0.7, anchor: .trailing)
                            }
                            Text("+" + (thisItem.additions[addition]! > 0 ?
                                         String(Double(thisItem.additions[addition]!) * Menu.Ingredient.price)
                                         : "0")
                                 + " BYN")
                            .font(.main(size: DrawingConstants.fontSize))
                            .foregroundColor(.deafultBrown)
                        }
                    }
                    Divider().overlay{
                        Color.primaryBrown
                    }
                    HStack {
                        Spacer(minLength: 0)
                        Text(String(thisItem.price) + " BYN")
                        .font(.main(size: DrawingConstants.fontSize))
                        .foregroundColor(.deafultBrown)
                    }
                    Spacer(minLength: 0)
                        .padding(.bottom, DrawingConstants.padding)
                }.padding(.trailing, DrawingConstants.padding)
            }
        }
        //.frame(height: DrawingConstants.imageSize + DrawingConstants.padding * 2)
    }
    
}

struct OrderItem_Previews: PreviewProvider {
    static var previews: some View {
        OrderItem(Order.Item(item: Menu.Item(id: 1, belogsTo: .Shawarma, name: "Shawa1", price: 8.99, image: UIImage(named: "ShawarmaPicture")!.pngData()!, dateAdded: Date(), popularity: 2, ingredients: [.Cheese, .Chiken, .Onion], description: "jiqdlcmqc fqdwhj;ksm'qwd qfhdwoj;ks;qds ewoq;jdklso;ef"), additions: [.Cheese:2, .Beef:1, .Onion:-1, .FreshCucumbers:3, .Pork: 1]), addOneIngredient: { ingredient, item in
            
        }, removeOneIngredient: { ingredient, item in
            
        })
        .previewDevice("iPhone 11 Pro")
    }
}
