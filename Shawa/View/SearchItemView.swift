//
//  SearchItemView.swift
//  Shawa
//
//  Created by Alex on 10.05.23.
//

import SwiftUI

struct SearchItemView: View {
    var thisItem: Menu.Item
    
    init(_ thisItem: Menu.Item) {
        self.thisItem = thisItem
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(lineWidth: 1)
                .foregroundColor(.lighterBrown)
            HStack(alignment: .center) {
                let imageSize: CGFloat = 64
                if let imageData = thisItem.image {
                    if let uiImage = UIImage(data: imageData){
                        Image(uiImage: uiImage)
                            .resizable(resizingMode: .stretch)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: imageSize, height: imageSize)
                            .cornerRadius(10)
                            .padding(.leading, 8)
                    } else {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 64))
                            .foregroundColor(.gray)
                            .frame(width: imageSize, height: imageSize)
                            .cornerRadius(10)
                            .padding(.leading, 8)
                    }
                } else {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 64))
                        .foregroundColor(.gray)
                        .frame(width: imageSize, height: imageSize)
                        .cornerRadius(10)
                        .padding(.leading, 8)
                }
                VStack(alignment: .leading) {
                    Text(thisItem.name)
                        .font(.main(size: 16))
                        .foregroundColor(.deafultBrown)
                        .padding(.top, 8)
                    Text(String(format: "%.2f", thisItem.price) + " BYN")
                        .font(.mainBold(size: 14))
                        .foregroundColor(.deafultBrown)
                    Spacer(minLength: 0)
                }
            }
        }
        .frame(height: 80)
        
    }
    
}

struct SearchItemView_Previews: PreviewProvider {
    static var previews: some View {
        SearchItemView(Menu.Item(id: 1, belogsTo: .Shawarma, name: "Shawa1", price: 8.99, image: UIImage(named: "ShawarmaPicture")!.pngData()!, dateAdded: Date(), popularity: 2, ingredients: [.Cheese, .Chiken, .Onion], description: "jiqdlcmqc fqdwhj;ksm'qwd qfhdwoj;ks;qds ewoq;jdklso;ef"))
            .previewDevice("iPhone 11 Pro")
    }
}
