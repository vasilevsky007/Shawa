//
//  OrderItemUnchangable.swift
//  Shawa
//
//  Created by Alex on 17.11.23.
//

import SwiftUI

struct OrderItemUnchangable: View {
    let thisItem: Order.Item
    let thisItemCount: Int
    
    init(_ thisItem: Order.Item, count: Int) {
        self.thisItem = thisItem
        self.thisItemCount = count
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
            VStack(alignment: .trailing, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    if let imageData = thisItem.item.image {
                        if let uiImage = UIImage(data: imageData){
                            Image(uiImage: uiImage)
                                .resizable(resizingMode: .stretch)
                                .aspectRatio(contentMode: .fit)
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
                                Text(thisItem.item.name)
                                    .font(.main(size: DrawingConstants.headerFontSize))
                                    .foregroundColor(.deafultBrown)
                                    .padding(.top, DrawingConstants.padding)
                                Text(String(format: "%.2f", thisItem.item.price) + " BYN")
                                    .font(.mainBold(size: DrawingConstants.fontSize))
                                    .foregroundColor(.deafultBrown)
                            }
                            Spacer(minLength: 0)

                        }

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
                                }
                                Text("+" + (thisItem.additions[addition]! > 0 ?
                                            String(format: "%.2f", Double(thisItem.additions[addition]!) * Menu.Ingredient.price)
                                             : "0")
                                     + " BYN")
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
        //.frame(height: DrawingConstants.imageSize + DrawingConstants.padding * 2)
    }
    
}

#Preview {
    OrderItemUnchangable(.init(item: .init(id: 1, belogsTo: .Shawarma, name: "saddq", price: 14.99, dateAdded: .now, popularity: 21, ingredients: Set(), description: "socdcc cdqin cqd cqicdwnxqdc iqcdw c"), additions: [:]), count: 1)
}
