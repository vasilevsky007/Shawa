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
    /// 95% of safe area
    static let extraLarge = Self.fraction(0.95)
    /// 280 points
    static let small = Self.height(280)
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

struct BackGesture: ViewModifier {
    var dismissThisView: () -> Void
    @GestureState private var dragOffset = CGSize.zero
    
    func body(content: Content) -> some View {
        let gesture = DragGesture().updating($dragOffset) { (value, _, _) in
            if(value.startLocation.x < 50 && value.translation.width > 100) {
                dismissThisView()
            }
        }
        return content
            .gesture(gesture, including: .all)
    }
}

extension View {
    func backGesture(_ dismiss: @escaping () -> Void) -> some View {
        self.modifier(BackGesture(dismissThisView: dismiss))
    }
}

struct SwipeToDeleteModifier: ViewModifier {
    let onDelete: () -> Void
    
    private let buttonWidth: CGFloat = 90
    
    @State private var contentHeight: CGFloat = 1
    @State private var contentWidth: CGFloat = 1
    @State private var offset: CGFloat = 0
    @State private var isSwiped: Bool = false
    

    func body(content: Content) -> some View {
        ZStack {
            // red delete button
            HStack {
                Spacer()
                
                Button {
                    withAnimation {
                        onDelete()
                    }
                } label: {
                    Image(systemName: "trash")
                        .font(.title)
                        .foregroundStyle(.background)
                        .frame(width: buttonWidth, height: contentHeight)
                }
            }
            .background(.red)
            
            // content
            content
                .background {
                    GeometryReader { geometry  in
                        DispatchQueue.main.async {
                            withAnimation {
                                contentHeight = geometry.frame(in: .local).size.height
                                contentWidth = geometry.frame(in: .local).size.width
                            }
                        }
                        return Color(UIColor.systemBackground)
                    }
                }
                .offset(x: offset)
                .highPriorityGesture(
                    DragGesture()
                        .onChanged(onChanged(value:))
                        .onEnded(onEnd(value:))
                )

        }
    }
    
    private func onChanged(value: DragGesture.Value) {
        if value.translation.width < 0 {
            if isSwiped {
                offset = value.translation.width - buttonWidth
            } else {
                offset = value.translation.width
            }
        }
    }
    
     private func onEnd(value: DragGesture.Value) {
        withAnimation(.easeOut) {
            if value.translation.width < 0 {
                if -value.translation.width > contentWidth / 2 {
                    offset = -10000
                    onDelete()
                } else if -offset > buttonWidth / 2 {
                    isSwiped = true
                    offset = -buttonWidth
                } else {
                    isSwiped = false
                    offset = 0
                }
            } else {
                isSwiped = false
                offset = 0
            }
        }
    }
}

extension View {
    func swipeToDelete(onDelete: @escaping () -> Void) -> some View {
        modifier(SwipeToDeleteModifier(onDelete: onDelete))
    }
}
