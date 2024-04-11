//
//  LoadableImage.swift
//  Shawa
//
//  Created by Alex on 31.03.24.
//

import SwiftUI

struct LoadableImage: View {
    var imageUrl: URL?
    var body: some View {
        if let imageUrl = imageUrl {
            AsyncImage(url: imageUrl) { image in
                image
                    .fillWithoutStretch()
            } placeholder: {
                ProgressView()
                    .tint(.deafultBrown)
            }
        } else {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: .Constants.LoadableImage.errorImageSize))
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    LoadableImage()
}
