//
//  PrettyLabel.swift
//  Shawa
//
//  Created by Alex on 10.11.23.
//

import SwiftUI

struct PrettyLabel: View {
    var cornerRadius: CGFloat
    var text: String
    var systemImage: String?
    var color: Color
    var font: Font
    var height: CGFloat
    var width: CGFloat?
    
    init (_ text: String,
          systemImage: String? = nil,
          font: Font = .main(size: 14),
          color: Color = .accentColor,
          cornerRadius: CGFloat = 10,
          width: CGFloat? = 326,
          height: CGFloat = 50){
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
            HStack(spacing: 13) {
                if let systemImage = systemImage {
                    Image(systemName: systemImage)
                        .font(.main(size: 20))
                }
                Text(text).foregroundColor(color).font(font)
                    
            }
                .padding(.horizontal, 15)
                .foregroundColor(color)
                .font(font)
        }.frame(width: width, height: height)
    }
}


#Preview {
    PrettyLabel("hello world", systemImage: "globe")
}
