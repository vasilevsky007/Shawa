//
//  FlowLayout.swift
//  Shawa
//
//  Created by Alex on 6.05.24.
//

import SwiftUI

struct FlowLayout<Id: Hashable, Content: View>: View {
    var items: [Id]
    var viewForItem: (Id) -> Content
    @State private var totalHeight: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            self.content(in: geometry)
        }
        .frame(height: totalHeight)
    }

    private func content(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        var lastHeight = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.items, id: \.self) { item in
                self.viewForItem(item)
                    .padding(.all, .Constants.halfSpacing)
                    .alignmentGuide(.leading) { dimensions in
                        if item == items.first {
                            height = .zero
                        }
                        if (abs(width - dimensions.width) > geometry.size.width) {
                            width = 0
                            height -= lastHeight
                        }
                        let result = width
                        if item == self.items.last {
                            width = 0 // last item
                        } else {
                            width -= dimensions.width
                        }
                        return result
                    }
                    .alignmentGuide(.top) { dimensions in
                        let result = height
                        lastHeight = dimensions.height
                        return result
                    }
            }
        }
        .background(viewHeightReader($totalHeight))
    }

    private func viewHeightReader(_ height: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            DispatchQueue.main.async {
                withAnimation {
                    height.wrappedValue = geometry.frame(in: .local).size.height
                }
            }
            return .clear
        }
    }
}
