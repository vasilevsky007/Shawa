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
    var label: String
    var submitLabel: SubmitLabel
    var submitAction: (()->Void)?
    var keyboardType: UIKeyboardType
    var image: String
    var color: Color
    var font: Font
    var height: CGFloat
    var width: CGFloat?
    
    var focusState: FocusState<FocusStateType>.Binding
    var focusedValue: FocusStateType
    
    init (text: Binding<String>, label: String = "", isSecured:Bool = false, submitLabel: SubmitLabel = .next, submitAction: (()->Void)? = nil, keyboardType:UIKeyboardType = .default, font: Font = .main(size: 14), color: Color = .accentColor, image: String = "", cornerRadius: CGFloat = 10, width: CGFloat? = 326, height: CGFloat = 50, focusState: FocusState<FocusStateType>.Binding, focusedValue: FocusStateType){
        self.cornerRadius = cornerRadius
        self.text = text
        self.secured = isSecured
        self.label = label
        self.submitLabel = submitLabel
        self.submitAction = submitAction
        self.keyboardType = keyboardType
        self.image = image
        self.color = color
        self.font = font
        self.height = height
        self.width = width
        
        self.focusState = focusState
        self.focusedValue = focusedValue
    }
    

    
    var body: some View {

        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(lineWidth: 1)
                .foregroundColor(color)
            if secured{
                SecureField(text: text) {
                    Text(label).foregroundColor(color).font(font)
                }
                    .focused(focusState, equals: focusedValue)
                    .autocorrectionDisabled()
                    .keyboardType(keyboardType)
                    .submitLabel(submitLabel)
                    .onSubmit {
                        submitAction?()
                    }
                    .padding(.leading, 50)
                    .foregroundColor(color)
                    .font(font)
            } else {
                TextField(text: text) {
                    Text(label).foregroundColor(color).font(font)
                }
                    .focused(focusState, equals: focusedValue)
                    .autocorrectionDisabled()
                    .keyboardType(keyboardType)
                    .submitLabel(submitLabel)
                    .onSubmit {
                        submitAction?()
                    }
                    .padding(.leading, 50)
                    .foregroundColor(color)
                    .font(font)
            }
            Image(image)
                .resizable(resizingMode: .stretch)
                .frame(width: 20, height: 20)
                .padding(.horizontal, 15)
        }.frame(width: width, height: height)
    }
}

