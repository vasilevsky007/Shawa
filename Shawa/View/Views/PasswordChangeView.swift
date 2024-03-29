//
//  PasswordChangeView.swift
//  Shawa
//
//  Created by Alex on 15.11.23.
//

import SwiftUI

struct PasswordChangeView: View {
    @Environment(\.dismiss) private var dismiss
    
    private struct DrawingConstants {
        static let pagePadding: CGFloat = 24
        static let padding: CGFloat = 8
    }
    
    private enum FocusableField: Hashable {
        case oldPassword, newPassword, newPasswordConfirm;
    }
    
    @State private var enteredOldPassword = ""
    @State private var enteredNewPassword = ""
    @State private var enteredNewPasswordConfirm = ""
    
    @FocusState private var focusedField: FocusableField?
    
    
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            HStack {
                Spacer(minLength: 0)
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 30))
                        .foregroundColor(.lighterBrown)
                        .padding(.top)
                }
            }
            Spacer(minLength: 0)
            Text("Old password")
                .font(.main(size: 16))
                .foregroundColor(.deafultBrown)
            PrettyTextField(
                text: $enteredOldPassword,
                color: .lighterBrown,
                isSystemImage: true,
                image: "lock.badge.clock",
                width: nil,
                focusState: $focusedField,
                focusedValue: .oldPassword
            )
                .background(.white, in: RoundedRectangle(cornerRadius: 10))
            
            Text("New password")
                .font(.main(size: 16))
                .foregroundColor(.deafultBrown)
            PrettyTextField(
                text: $enteredNewPassword, 
                color: .lighterBrown,
                isSystemImage: true,
                image: "lock",
                width: nil,
                focusState: $focusedField,
                focusedValue: .newPassword
            )
                .background(.white, in: RoundedRectangle(cornerRadius: 10))
            
            Text("Confirm new password")
                .font(.main(size: 16))
                .foregroundColor(.deafultBrown)
            PrettyTextField(
                text: $enteredNewPasswordConfirm,
                color: .lighterBrown,
                isSystemImage: true,
                image: "lock.rotation",
                width: nil,
                focusState: $focusedField,
                focusedValue: .newPasswordConfirm
            )
                .background(.white, in: RoundedRectangle(cornerRadius: 10))
            
            PrettyButton(text: "Change Password", isActive: true) {
                //TODO: change password
            }
            .disabled(true)
                .frame(height: 50)
                .padding(.top, 8)
            Spacer(minLength: 0)
        }
            .padding(DrawingConstants.pagePadding)
            .ignoresSafeArea(.container, edges: .bottom)
    }
}

#Preview {
    @State var isChangingPassword =  true
    return Color.red
        .sheet(isPresented: $isChangingPassword) {
            if #available(iOS 16.0, *) {
                PasswordChangeView()
                    .presentationDetents([.medium])
            } else {
                // Fallback on earlier versions
            }
        }
}
