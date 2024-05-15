//
//  Header.swift
//  Shawa
//
//  Created by Alex on 14.03.23.
//

import SwiftUI


struct Header<TrailingLink>: View where TrailingLink: View {
    var leadingIcon: String = "MenuIcon"
    var leadingNumber: Int = 0
    var trailingNumber: Int = 0
    var noTrailingLink: Bool = false
    var leadingAction: () -> Void = { }
    var trailingLink: () -> TrailingLink
    
    
    var body: some View {
        HStack {
            Button {
                leadingAction()
            } label: {
                Image(leadingIcon)
                    .resizable(resizingMode: .stretch)
                    .frame(width: .Constants.Header.iconSize, height: .Constants.Header.iconSize)
                    .overlay(alignment: .topTrailing) {
                        if leadingNumber > 0 {
                            NumberSticker(numberToDisplay: leadingNumber)
                                .fixedSize()
                                .position(x: .Constants.Header.iconSize + .Constants.standardSpacing)
                        }
                    }
            }
            Spacer()
            logoBody
            Spacer()
            if !noTrailingLink {
                NavigationLink {
                    trailingLink()
                } label: {
                    Image("CartIcon")
                        .resizable(resizingMode: .stretch)
                        .frame(width: .Constants.Header.iconSize, height: .Constants.Header.iconSize)
                        .overlay(alignment: .topTrailing) {
                            if trailingNumber > 0 {
                                NumberSticker(numberToDisplay: trailingNumber)
                                    .fixedSize()
                                    .position(x: .Constants.Header.iconSize + .Constants.standardSpacing)
                            }
                        }
                }
            } else {
                Color.clear.frame(width: .Constants.Header.iconSize)
            }
        }.frame(height: .Constants.Header.height, alignment: .top)
    }
    var logoBody: some View {
        HStack {
            Image("Logo")
                .resizable(resizingMode: .stretch)
                .frame(width: .Constants.Header.iconSize, height: .Constants.Header.iconSize)
            Text("Shawa")
                .font(.logo(size: 19))
                .foregroundColor(Color.defaultBrown)
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        Header(leadingNumber: 99, trailingNumber: 99) {
            Text("")
        }
    }
}
