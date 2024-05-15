//
//  NumberSticker.swift
//  Shawa
//
//  Created by Alex on 15.05.24.
//

import SwiftUI

struct NumberSticker: View {
    let numberToDisplay: Int
    
    private var textToDisplay: String {
        numberToDisplay.magnitude < 100 ? numberToDisplay.description : numberToDisplay < 0 ? "99-" : "99+"
    }
    
    var body: some View {
        Text(textToDisplay)
            .font(.mainBold(size: 12))
            .foregroundStyle(.white)
            .padding(.horizontal, 
                .Constants.standardSpacing * (textToDisplay.count > 1 ? 1 : 1.2)
            )
            .padding(.vertical, .Constants.halfSpacing)
            .background(.red, in: .capsule)
    }
}

#Preview {
    NumberSticker(numberToDisplay: -101)
}
