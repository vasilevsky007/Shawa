//
//  Header.swift
//  Shawa
//
//  Created by Alex on 14.03.23.
//

import SwiftUI

struct Header: View {
    var leadingIcon: String
    var leadingAction: () -> Void
    var trailingAction: ()-> Void
    init(leadingIcon: String = "MenuIcon", leadingAction: @escaping () -> Void = { }, trailingAction: @escaping () -> Void = { }) {
        self.leadingIcon = leadingIcon
        self.leadingAction = leadingAction
        self.trailingAction = trailingAction
    }
    var body: some View {
        VStack {
            HStack {
                Button {
                    leadingAction()
                } label: {
                    Image(leadingIcon).resizable(resizingMode: .stretch).frame(width: 25, height: 25)
                }
                
                Spacer()
                logoBody
                Spacer()
                Button {
                    trailingAction()
                } label: {
                    Image("CartIcon").resizable(resizingMode: .stretch).frame(width: 25, height: 25)
                }

                
            }
        }
    }
    var logoBody: some View {
        HStack {
            Image("Logo").resizable(resizingMode: .stretch).frame(width: 25, height: 25)
            Text("Shawa").font(.logo(size: 19)).foregroundColor(.deafultBrown)
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        Header()
    }
}
