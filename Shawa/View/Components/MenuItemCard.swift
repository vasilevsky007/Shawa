//
//  MenuItemCard.swift
//  Shawa
//
//  Created by Alex on 12.03.23.
//

import SwiftUI

struct MenuItemCard: View {
    var thisItem: MenuItem
    
    init(_ item: MenuItem) {
        thisItem = item
    }
    
    private struct DrawingConstants {
        static var cornerRadius: CGFloat = 15
        static var imageCornerRadius: CGFloat = 10
        static var allPadding: CGFloat = 10
        static var additionalVerticalPadding: CGFloat = 5
        static var fontSize: CGFloat = 14
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                    .foregroundColor(.white)
                VStack(alignment: .leading) {
                    let imageSize = (geometry.size.width - 2 * DrawingConstants.allPadding) > 0 ? (geometry.size.width - 2 * DrawingConstants.allPadding) : nil
                    LoadableImage(imageUrl: thisItem.image)
                        .frame(width: imageSize, height: imageSize, alignment: .center)
                        .cornerRadius(DrawingConstants.imageCornerRadius)
                        .padding(.top, DrawingConstants.additionalVerticalPadding)
                    Spacer(minLength: 0)
                    Text(thisItem.name)
                        .font(.main(size: DrawingConstants.fontSize))
                        .foregroundColor(.deafultBrown)
                    Text(String(format: "%.2f", thisItem.price) + " BYN")
                        .font(.mainBold(size: DrawingConstants.fontSize))
                        .foregroundColor(.deafultBrown)
                        .padding(.bottom, DrawingConstants.additionalVerticalPadding)
                }
                .padding(.all, DrawingConstants.allPadding)
            }
        }
    }
}

struct MenuItemCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.red
            MenuItemCard(RestaurantManagerStub().restaurants.value!.first!.menu.first!)
                .frame(width: 160, height: 220)
        }.previewDevice("iPhone 11 Pro")
    }
}
