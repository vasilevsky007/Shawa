//
//  ConditionalTextEditor.swift
//  Shawa
//
//  Created by Alex on 15.11.23.
//

import Foundation
import SwiftUI

struct ConditionalTextEditor: View {
    @Binding var isEditing: Bool
    @Binding var value: String
    let systemImage: String
    let onEditingEnded: () -> Void
    
    var body: some View {
        if isEditing {
            PrettyTextField<String>(text: $value, color: .lighterBrown, isSystemImage: true, image: systemImage, width: nil)
                .background(.white, in: RoundedRectangle(cornerRadius: .Constants.elementCornerRadius))
                .overlay(alignment: .trailing) {
                    PrettyEditButton(isEditing: $isEditing, color: .lighterBrown){
                        onEditingEnded()
                    }
                    .padding(.all, .Constants.halfSpacing)
                }
        } else {
            PrettyLabel(value, systemImage: systemImage, color: .lighterBrown)
                .background(.white, in: RoundedRectangle(cornerRadius: .Constants.elementCornerRadius))
                .overlay(alignment: .trailing) {
                    PrettyEditButton(isEditing: $isEditing, color: .lighterBrown) {
                        onEditingEnded()
                    }
                    .padding(.all, .Constants.halfSpacing)
                }
        }
    }
}

#Preview {
    @State var e = false
    @State var v = "asd"
    return ConditionalTextEditor(isEditing: $e, value: $v, systemImage: "globe", onEditingEnded: {}).padding()
}
