//
//  PrettyButton.swift
//  Shawa
//
//  Created by Alex on 14.03.23.
//

import SwiftUI

struct PrettyButton: View {
    var text: String
    var systemImage = "noImage"
    var fontsize: CGFloat = 14
    var isSwitch = false
    var unactiveColor = Color.clear
    @State var isActive = false
    var onTap: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            // MARK: active
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.primaryBrown)
                Button {
                    withAnimation {
                        if isSwitch {
                            isActive.toggle()
                        }
                        onTap()
                    }
                } label: {
                    HStack(alignment: .center) {
                        if systemImage != "noImage" {
                            Image(systemName: systemImage)
                                .foregroundColor(.white)
                                .font(.system(size: geometry.size.height - 20))
                        }
                        Text(text).font(.main(size: fontsize)).foregroundColor(.white)
                    }
                    
                }
            }.opacity(isActive ? 1 : 0)
            //MARK: unactive
            ZStack (alignment: .center) {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(unactiveColor)
                Button {
                    withAnimation {
                        if isSwitch {
                            isActive.toggle()
                        }
                        onTap()
                    }
                } label: {
                    HStack(alignment: .center) {
                        if systemImage != "noImage" {
                            Image(systemName: systemImage)
                                .foregroundColor(.deafultBrown)
                                .font(.system(size: geometry.size.height - 20))
                        }
                        Text(text).font(.main(size: fontsize)).foregroundColor(.deafultBrown)
                    }
                    
                }
            }.opacity(isActive ? 0 : 1)
        }

    }
}

struct PrettyButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PrettyButton(text: "Chicken", systemImage: "slider.vertical.3", isSwitch: true, unactiveColor: .lightBrown, onTap: {}).frame(width: 92, height: 41)
        
        PrettyButton(text: "Add to cart",systemImage: "cart.badge.plus", fontsize: 16, isActive: true) {
            
        }.frame(width: 120, height:60).padding(.trailing, 10)
    }
}
