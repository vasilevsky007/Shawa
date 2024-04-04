//
//  SwiftUIHelpers.swift
//  Shawa
//
//  Created by Alex on 30.03.24.
//

import SwiftUI

extension Image {
    /// image view perfectly fitted: no blank space, no stretch!
    /// can cut sides if wrong aspect ratio
    func fillWithoutStretch() -> some View {
        self
            .resizable(resizingMode: .stretch)
            .aspectRatio(contentMode: .fit)
            .aspectRatio(contentMode: .fill)
    }
}

@available(iOS 16.0, *)
extension PresentationDetent {
    static let extraLarge = Self.fraction(0.95)
}

fileprivate struct FormHiddenBackground: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content.onAppear {
                UITableView.appearance().backgroundColor = .clear
            }
            .onDisappear {
                UITableView.appearance().backgroundColor = .systemGroupedBackground
            }
        }
    }
}

extension Form {
    func defaultBackgroundHidden() -> some View  {
        self.modifier(FormHiddenBackground())
    }
}

struct RefreshControlColor: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content.onAppear {
            UIRefreshControl.appearance().tintColor = UIColor(color)
        }
        .onDisappear {
            UIRefreshControl.appearance().tintColor = nil
        }
    }
}
extension View {
    func refreshControlColor(_ color: Color) -> some View  {
        self.modifier(RefreshControlColor(color: color))
    }
}
