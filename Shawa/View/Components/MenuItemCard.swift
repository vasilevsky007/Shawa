//
//  MenuItemCard.swift
//  Shawa
//
//  Created by Alex on 12.03.23.
//

import SwiftUI

/// you have to ensure enclosing in frame.
struct MenuItemCard: View {
    var thisItem: MenuItem
    
    init(_ item: MenuItem) {
        thisItem = item
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                LoadableImage(imageUrl: thisItem.image)
                    .frame(width: geometry.size.width, height: geometry.size.width, alignment: .center)
                    .cornerRadius(.Constants.elementCornerRadius)
                    .padding(.bottom, .Constants.standardSpacing)
                Text(thisItem.name)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .font(.main(size: 14))
                    .foregroundColor(.deafultBrown)
                Spacer(minLength: 0)
                Text(String(format: "%.2f", thisItem.price) + " BYN")
                    .font(.mainBold(size: 14))
                    .foregroundColor(.deafultBrown)
            }
        }
        .padding(.all, .Constants.standardSpacing)
        .padding(.vertical, .Constants.halfSpacing)
        .background(Color.white, in: .rect(cornerRadius: .Constants.MenuItemCard.cornerRadius))
    }
}

#Preview {
    ZStack{
        Color.red
        MenuItemCard(RestaurantManagerStub().restaurants.value!.first!.menu.first!)
            .frame(width: 160, height: 232)
    }
}
