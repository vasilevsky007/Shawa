//
//  ActionButton.swift
//  Shawa
//
//  Created by Alex on 4.04.24.
//

import SwiftUI

struct ActionButton: View {
    private var state: State
    private var action: () -> Void
    private var height: CGFloat
    private var color: Color
    private var disabledColor: Color
    
    init(state: State,
         height: CGFloat = .Constants.lineElementHeight,
         color: Color = .primaryBrown,
         disabledColor: Color = .gray,
         action: @escaping () -> Void) {
        self.state = state
        self.height = height
        self.color = color
        self.disabledColor = disabledColor
        self.action = action
    }
    
    var body: some View {
        Button {
            switch state {
            case .active(_):
                action()
            default:
                break
            }
        } label: {
            HStack(alignment: .center) {
                Spacer(minLength: 0)
                if state.isLoading {
                    ProgressView()
                        .tint(.white)
                }
                Text(state.label)
                    .font(.mainBold(size: 16))
                    .foregroundStyle(.white)
                Spacer(minLength: 0)
            }
        }
        .frame(minHeight: height)
        .background(
            state.isEnabled ? color : disabledColor,
            in: RoundedRectangle(cornerRadius: .Constants.cornerRadius)
        )
    }
}

extension ActionButton {
    enum State {
        case loading(label: LocalizedStringKey)
        case active(label: LocalizedStringKey)
        case disabled(label: LocalizedStringKey)
        
        var label: LocalizedStringKey {
            switch self {
            case .loading(let label):
                label
            case .active(let label):
                label
            case .disabled(let label):
                label
            }
        }
        var isEnabled: Bool {
            switch self {
            case .disabled(_):
                false
            default:
                true
            }
        }
        var isLoading: Bool {
            switch self {
            case .loading(_):
                true
            default:
                false
            }
        }
    }
}

#Preview {
    ActionButton(state: .loading(label: "")) {
        
    }
}
