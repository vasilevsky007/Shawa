//
//  PrettyButton.swift
//  Shawa
//
//  Created by Alex on 14.03.23.
//

import SwiftUI

struct PrettyButton: View {
    var text: LocalizedStringKey
    var systemImage = "noImage"
    var fontsize: CGFloat = 16
    var isSwitch = false
    var color = Color.primaryBrown
    var unactiveColor = Color.clear
    var isActive = false //TODO: was @State
    var onTap: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            if isActive {
                // MARK: active
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: .Constants.elementCornerRadius)
                        .foregroundColor(color)
                    Button {
                        withAnimation {
                            if isSwitch {
                                //isActive.toggle()
                            }
                            onTap()
                        }
                    } label: {
                        HStack(alignment: .center) {
                            Spacer(minLength: 0)
                            if systemImage != "noImage" {
                                Image(systemName: systemImage)
                                    .foregroundColor(.white)
                                    .font(.system(size: geometry.size.height - .Constants.PrettyButton.imageInsets))
                            }
                            Text(text).font(.main(size: fontsize)).foregroundColor(.white)
                            Spacer(minLength: 0)
                        }.padding(.all, .Constants.standardSpacing)
                    }
                }.transition(.opacity)
            } else {
                //MARK: unactive
                ZStack (alignment: .center) {
                    RoundedRectangle(cornerRadius: .Constants.elementCornerRadius)
                        .strokeBorder(unactiveColor)
                    Button {
                        withAnimation {
                            if isSwitch {
                                //isActive.toggle()
                            }
                            onTap()
                        }
                    } label: {
                        HStack(alignment: .center) {
                            Spacer(minLength: 0)
                            if systemImage != "noImage" {
                                Image(systemName: systemImage)
                                    .foregroundColor(.deafultBrown)
                                    .font(.system(size: geometry.size.height - .Constants.PrettyButton.imageInsets))
                            }
                            Text(text).font(.main(size: fontsize)).foregroundColor(.deafultBrown)
                            Spacer(minLength: 0)
                        }.padding(.all, .Constants.standardSpacing)
                    }
                }.transition(.opacity)
            }
        }

    }
}

#Preview {
    PrettyButton(text: "", systemImage: "slider.vertical.3", isSwitch: true, unactiveColor: .lightBrown, onTap: {}).frame(width: 120, height: 41)
}
#Preview {
    PrettyButton(text: "Add to cart",systemImage: "cart.badge.plus", fontsize: 16, isActive: true) {
        
    }.frame(width: 120, height:60).padding(.trailing, 10)
}
#Preview {
        PrettyButton(text: "Log out", systemImage: "rectangle.portrait.and.arrow.right", unactiveColor: .red, isActive: false) {
            print("logout")
        }.frame(height: 40)
    }
