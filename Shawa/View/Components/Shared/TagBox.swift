//
//  TagBox.swift
//  Shawa
//
//  Created by Alex on 14.05.24.
//

import SwiftUI

struct TagBox: View {
    var text: LocalizedStringKey
    var isDeletable = false
    var deleteAction: () -> Void = {}
    var body: some View {
        HStack (spacing: 0) {
            Text(text)
                .font(.main(size: 14))
                .foregroundColor(.lightBrown)
                .padding(.horizontal, .Constants.standardSpacing)
                .padding(.vertical, .Constants.halfSpacing)
            if isDeletable {
                Button {
                    deleteAction()
                } label: {
                    Image(systemName: "trash")
                        .font(.main(size: 14))
                        .foregroundStyle(.white)
                }
                .padding(.Constants.halfSpacing)
                .background(.red, in: .circle)
            }
        }
        .background(.primaryBrown, in: .capsule.stroke(lineWidth: .Constants.doubleBorderWidth))
    }
}

#Preview {
    VStack {
        TagBox(text: "")
        TagBox(text: "", isDeletable: true)
    }
}
