//
//  PrettyTextField.swift
//  Shawa
//
//  Created by Alex on 10.03.23.
//

import SwiftUI

struct PrettyTextField<FocusStateType: Hashable>: View {
    var cornerRadius: CGFloat
    var text: Binding<String>
    var secured: Bool
    var label: LocalizedStringKey
    var submitLabel: SubmitLabel
    var submitAction: (()->Void)?
    var keyboardType: UIKeyboardType
    var isSystemImage: Bool
    var image: String
    var color: Color
    var font: Font
    var height: CGFloat
    var width: CGFloat?
    
    var focusState: FocusState<FocusStateType>.Binding?
    var focusedValue: FocusStateType?
    
    init (
        text: Binding<String>,
        label: LocalizedStringKey = "",
        isSecured:Bool = false,
        font: Font = .main(size: 14),
        color: Color = .accentColor,
        isSystemImage: Bool = false,
        image: String = "",
        cornerRadius: CGFloat = .Constants.elementCornerRadius,
        width: CGFloat? = nil,
        height: CGFloat = .Constants.lineElementHeight,
        focusState: FocusState<FocusStateType>.Binding? = nil,
        focusedValue: FocusStateType? = nil,
        keyboardType: UIKeyboardType = .default,
        submitLabel: SubmitLabel = .next,
        submitAction: (()->Void)? = nil) {
        self.cornerRadius = cornerRadius
        self.text = text
        self.secured = isSecured
        self.label = label
        self.submitLabel = submitLabel
        self.submitAction = submitAction
        self.keyboardType = keyboardType
        self.isSystemImage = isSystemImage
        self.image = image
        self.color = color
        self.font = font
        self.height = height
        self.width = width
        
        self.focusState = focusState
        self.focusedValue = focusedValue
    }
    

    var secureField: some View {
        SecureField(text: text) {
            Text(label).foregroundColor(color).font(font)
        }
            .autocorrectionDisabled()
            .keyboardType(keyboardType)
            .submitLabel(submitLabel)
            .onSubmit {
                submitAction?()
            }
            .padding(.leading, .Constants.PrettyTextField.fieldsLeadingPadding)
            .foregroundColor(color)
            .font(font)
    }
    
    var textField: some View {
        TextField(text: text) {
            Text(label).foregroundColor(color).font(font)
        }
            .autocorrectionDisabled()
            .keyboardType(keyboardType)
            .submitLabel(submitLabel)
            .onSubmit {
                submitAction?()
            }
            .padding(.leading, .Constants.PrettyTextField.fieldsLeadingPadding)
            .foregroundColor(color)
            .font(font)
    }
    
    @ViewBuilder var imageView: some View {
        if(isSystemImage){
            Image(systemName: image)
                .font(.main(size: .Constants.PrettyTextField.imageSize))
                .foregroundColor(color)
                .padding(.horizontal, .Constants.PrettyTextField.imagePadding)
        } else {
            Image(image)
                .resizable(resizingMode: .stretch)
                .foregroundColor(color)
                .frame(width: .Constants.PrettyTextField.imageSize, height: .Constants.PrettyTextField.imageSize)
                .padding(.horizontal, .Constants.PrettyTextField.imagePadding)
        }
    }
    
    var body: some View {

        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(lineWidth: .Constants.borderWidth)
                .foregroundColor(color)
            if secured{
                if let focusState = focusState, let focusedValue = focusedValue {
                    secureField
                        .focused(focusState, equals: focusedValue)
                } else {
                    secureField
                }
            } else {
                if let focusState = focusState, let focusedValue = focusedValue {
                    textField
                        .focused(focusState, equals: focusedValue)
                } else {
                    textField
                }
            }
            imageView
            
        }.frame(width: width, height: height)
    }
}

#Preview {
    @State var t = ""
    return PrettyTextField<Bool>(text: $t,label: "", isSystemImage:true, image: "globe")
}
