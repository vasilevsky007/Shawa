//
//  PrettyEditButton.swift
//  Shawa
//
//  Created by Alex on 10.11.23.
//

import SwiftUI

struct PrettyEditButton: View {
    var isEditing: Binding<Bool>
    var cornerRadius: CGFloat
    var color: Color
    var font: Font
    var height: CGFloat
    var width: CGFloat?
    var onEditingEnded: () -> Void
    
    init (isEditing: Binding<Bool>,
          font: Font = .main(size: 14),
          color: Color = .red,
          cornerRadius: CGFloat = .Constants.elementCornerRadius,
          height: CGFloat = .Constants.PrettyEditButton.defaultHeight,
          onEditingEnded: @escaping () -> Void) {
        self.isEditing = isEditing
        self.cornerRadius = cornerRadius
        self.color = color
        self.font = font
        self.height = height
        self.onEditingEnded = onEditingEnded
    }
    
    
    
    var body: some View {
        
        Button(isEditing.wrappedValue ? "Save" : "Edit") {
            if isEditing.wrappedValue {
                onEditingEnded()
            }
            isEditing.wrappedValue.toggle()
        }
        .foregroundColor(color)
        .font(font)
        .padding(.all, .Constants.doubleSpacing)
        .frame(height: height)
        .background {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(lineWidth: .Constants.borderWidth)
                .foregroundStyle(color)
        }
    }
}

#Preview {
    @State var a = false
    return PrettyEditButton(isEditing: $a, onEditingEnded: {print(a)})
}
