//
//  SearchItem.swift
//  Shawa
//
//  Created by Alex on 10.05.23.
//

import SwiftUI

struct SearchItem: View {
    var thisItem: MenuItem
    
    init(_ thisItem: MenuItem) {
        self.thisItem = thisItem
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: .Constants.elementCornerRadius)
                .strokeBorder(lineWidth: .Constants.borderWidth)
                .foregroundColor(.lighterBrown)
            HStack(alignment: .center) {
                let imageSize: CGFloat = .Constants.SearchItem.imageSize
                LoadableImage(imageUrl: thisItem.image)
                    .frame(width: imageSize, height: imageSize, alignment: .center)
                    .cornerRadius(.Constants.elementCornerRadius)
                    .padding(.leading, .Constants.standardSpacing)
                VStack(alignment: .leading) {
                    Text(thisItem.name)
                        .font(.main(size: 16))
                        .foregroundColor(.defaultBrown)
                        .padding(.top, .Constants.standardSpacing)
                    Text(String(format: "%.2f", thisItem.price) + " BYN")
                        .font(.mainBold(size: 14))
                        .foregroundColor(.defaultBrown)
                    Spacer(minLength: 0)
                }
            }
        }
        .frame(height: .Constants.SearchItem.height)
        
    }
    
}

#Preview {
    SearchItem(.init(
        id: "",
        sectionIDs: Set<String>(),
        name: "Item1 xdd",
        price: 8.99,
        image: .init(string: "https://upload.wikimedia.org/wikipedia/ru/d/d8/Tianasquare.jpg"),
        dateAdded: Date(),
        popularity: 123,
        ingredientIDs: Set<String>(),
        description: ""))
}
