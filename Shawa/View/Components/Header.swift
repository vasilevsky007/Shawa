//
//  Header.swift
//  Shawa
//
//  Created by Alex on 14.03.23.
//

import SwiftUI


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
        HStack {
            Button {
                leadingAction()
            } label: {
                Image(leadingIcon)
                    .resizable(resizingMode: .stretch)
                    .frame(width: .Constants.Header.iconSize, height: .Constants.Header.iconSize)
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
                .foregroundColor(.deafultBrown)
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        Header(trailingLink: {Text("")})
    }
}
