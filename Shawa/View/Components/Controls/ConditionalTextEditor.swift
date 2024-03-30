//
//  ConditionalTextEditor.swift
//  Shawa
//
//  Created by Alex on 15.11.23.
//

import Foundation
import SwiftUI

@ViewBuilder func conditionalTextEditor(isEditing: Binding<Bool>, value: Binding<String>, systemImage: String, onEditingEnded: @escaping () -> Void) -> some View {
    if isEditing.wrappedValue {
        PrettyTextField<String>(text: value, color: .lighterBrown, isSystemImage: true, image: systemImage, width: nil)
            .background(.white, in: RoundedRectangle(cornerRadius: 10))
            .overlay(alignment: .trailing) {
                PrettyEditButton(isEditing: isEditing, color: .lighterBrown){
                    onEditingEnded()
                }
                    .padding(.trailing, 6)
            }
    } else {
        PrettyText(value.wrappedValue, color: .lighterBrown, width: nil)
            .background(.white, in: RoundedRectangle(cornerRadius: 10))
            .overlay(alignment: .trailing) {
                PrettyEditButton(isEditing: isEditing, color: .lighterBrown) {
                    onEditingEnded()
                }
                    .padding(.trailing, 6)
            }
    }
    
}
