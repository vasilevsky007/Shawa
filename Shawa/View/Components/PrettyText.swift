//
//  PrettyText.swift
//  Shawa
//
//  Created by Alex on 10.11.23.
//

import SwiftUI

struct PrettyText: View {
    var cornerRadius: CGFloat
    var text: String
    var color: Color
    var font: Font
    var height: CGFloat
    var width: CGFloat?
    
    init (_ text: String, font: Font = .main(size: 14), color: Color = .accentColor, cornerRadius: CGFloat = 10, width: CGFloat? = 326, height: CGFloat = 50){
        self.cornerRadius = cornerRadius
        self.text = text
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
            Text(text).foregroundColor(color).font(font)
                .padding(.leading, 15)
                .foregroundColor(color)
                .font(font)
        }.frame(width: width, height: height)
    }
}


#Preview {
    PrettyText("hello world")
}
