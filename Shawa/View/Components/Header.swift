//
//  Header.swift
//  Shawa
//
//  Created by Alex on 14.03.23.
//

import SwiftUI

fileprivate struct DrawingConstants {
    static let iconSize: CGFloat = 25
    static let logoFont: CGFloat = 19
}

struct Header<TrailingLink>: View where TrailingLink: View {
    var leadingIcon: String
    var leadingAction: () -> Void
    var noTrailingLink: Bool
    var trailingLink: () -> TrailingLink
    
    init(leadingIcon: String = "MenuIcon", leadingAction: @escaping () -> Void = { }, noTrailingLink: Bool = false, trailingLink: @escaping ()-> TrailingLink) {
        self.leadingIcon = leadingIcon
        self.leadingAction = leadingAction
        self.noTrailingLink = noTrailingLink
        self.trailingLink = trailingLink
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    leadingAction()
                } label: {
                    Image(leadingIcon)
                        .resizable(resizingMode: .stretch)
                        .frame(width: DrawingConstants.iconSize, height: DrawingConstants.iconSize)
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
                            .frame(width: DrawingConstants.iconSize, height: DrawingConstants.iconSize)
                    }
                } else {
                    Spacer().frame(width: 25)
                }

                
            }
        }
    }
    var logoBody: some View {
        HStack {
            Image("Logo")
                .resizable(resizingMode: .stretch)
                .frame(width: DrawingConstants.iconSize, height: DrawingConstants.iconSize)
            Text("Shawa")
                .font(.logo(size: DrawingConstants.logoFont))
                .foregroundColor(.deafultBrown)
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        Header(trailingLink: {Text("hello")})
    }
}
