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
    var color = Color.primaryBrown
    var unactiveColor = Color.clear
    var isActive = false
    var infiniteWidth = false
    var onTap: () -> Void
    
    @State private var totalWidth: CGFloat? = nil
    
    var body: some View {
        GeometryReader { geometry in
            Button {
                withAnimation {
                    onTap()
                }
            } label: {
                HStack(alignment: .center, spacing: 0) {
                    if (infiniteWidth) {
                        Spacer(minLength: 0)
                    }
                    if systemImage != "noImage" {
                        Image(systemName: systemImage)
                            .foregroundStyle(isActive ? .white : .defaultBrown)
                            .font(.system(size: geometry.size.height - .Constants.PrettyButton.imageInsets))
                            .padding(.trailing, .Constants.standardSpacing)
                    } else {
                        Color.clear
                            .frame(width: 1, height: geometry.size.height - .Constants.PrettyButton.imageInsets)
                    }
                    Text(text)
                        .font(.main(size: fontsize))
                        .foregroundColor(isActive ? .white : .defaultBrown)
                    if (infiniteWidth) {
                        Spacer(minLength: 0)
                    }
                }
                .padding(.all, .Constants.standardSpacing)
                .background {
                    GeometryReader { geometry in
                        Group {
                            if isActive {
                                RoundedRectangle(cornerRadius: .Constants.elementCornerRadius)
                                    .foregroundStyle(color)
                            } else {
                                RoundedRectangle(cornerRadius: .Constants.elementCornerRadius)
                                    .strokeBorder(unactiveColor)
                            }
                        }.onAppear {
                            DispatchQueue.main.async {
                                withAnimation {
                                    totalWidth = geometry.frame(in: .local).size.width
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        .frame(width: infiniteWidth ? nil : totalWidth)
    }
}

#Preview {
    PrettyButton(text: "sended", systemImage: "slider.vertical.3", unactiveColor: .lightBrown, onTap: {})
        .frame(height: .Constants.lineElementHeight)
}
#Preview {
    PrettyButton(text: "Add to cart",systemImage: "cart.badge.plus", fontsize: 16, isActive: true) {
        
    }.frame(height:60)
        .frame(idealWidth: 80, maxWidth: 160)
        .padding(.trailing, 10)
}
#Preview {
    PrettyButton(text: "Log out", systemImage: "rectangle.portrait.and.arrow.right", unactiveColor: .red, isActive: false, infiniteWidth: true) {
        print("logout")
    }.frame(height: 40)
}
