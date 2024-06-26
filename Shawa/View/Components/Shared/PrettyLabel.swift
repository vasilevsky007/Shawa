//
//  PrettyLabel.swift
//  Shawa
//
//  Created by Alex on 10.11.23.
//

import SwiftUI

struct PrettyLabel: View {
    var cornerRadius: CGFloat
    var text: LocalizedStringKey
    var systemImage: String?
    var color: Color
    var font: Font
    var height: CGFloat
    var width: CGFloat?
    
    init (_ text: LocalizedStringKey,
          systemImage: String? = nil,
          font: Font = .main(size: 14),
          color: Color = .accentColor,
          cornerRadius: CGFloat = .Constants.elementCornerRadius,
          width: CGFloat? = nil,
          height: CGFloat = .Constants.lineElementHeight){
        self.cornerRadius = cornerRadius
        self.text = text
        self.systemImage = systemImage
        self.color = color
        self.font = font
        self.height = height
        self.width = width
    }
    
    
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(lineWidth: 1)
                .foregroundColor(color)
            HStack(spacing: .Constants.PrettyLabel.spacing) {
                if let systemImage = systemImage {
                    Image(systemName: systemImage)
                        .font(.main(size: 20))
                }
                
                Text(text)
                    .font(font)
                    .foregroundColor(color)
                    .tint(color)
            }
                .padding(.horizontal, .Constants.PrettyLabel.spacing)
                .foregroundColor(color)
                .font(font)
        }.frame(width: width, height: height)
    }
}


#Preview {
    PrettyLabel("hello world", systemImage: "globe", color: .red, width: 100)
}
