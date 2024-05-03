//
//  PasswordChangeView.swift
//  Shawa
//
//  Created by Alex on 15.11.23.
//

import SwiftUI

struct PasswordChangeView<AuthenticationManagerType: AuthenticationManager>: View {
    @EnvironmentObject private var authenticationManager: AuthenticationManagerType
    @Environment(\.dismiss) private var dismiss
    
    var background: Color? = nil
    
    private enum FocusableField: Hashable {
        case oldPassword, newPassword, newPasswordConfirm;
    }
    
    @State private var enteredOldPassword = ""
    @State private var enteredNewPassword = ""
    @State private var enteredNewPasswordConfirm = ""
    
    private var newPasswordsValidated: Bool {
        //TODO: better validation
        enteredNewPassword == enteredNewPasswordConfirm && enteredNewPassword != ""
    }
    
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
                .padding(.horizontal, .Constants.horizontalSafeArea)
                .padding(.top, .Constants.standardSpacing)
            Spacer(minLength: 0)
            if #available(iOS 16.4, *) {
                ScrollView {
                    scrollContentBody
                    .padding(.Constants.horizontalSafeArea)
                    .background {
                        background
                    }
                }
                .scrollIndicators(.never)
                .scrollBounceBehavior(.basedOnSize)
            } else {
                ScrollView {
                    scrollContentBody
                        .padding(.Constants.horizontalSafeArea)
                        .background {
                            background
                        }
                }
            }
        }
            .ignoresSafeArea(.container, edges: .bottom)

    }
    
    private var scrollContentBody: some View {
        VStack (alignment: .leading, spacing: 8) {
            Text("Old password")
                .font(.main(size: 16))
                .foregroundColor(.defaultBrown)
            PrettyTextField(
                text: $enteredOldPassword,
                color: .lighterBrown,
                isSystemImage: true,
                image: "lock.badge.clock",
                width: nil,
                focusState: $focusedField,
                focusedValue: .oldPassword
            )
            .background(.white, in: RoundedRectangle(cornerRadius: .Constants.elementCornerRadius))
            
            Text("New password")
                .font(.main(size: 16))
                .foregroundColor(.defaultBrown)
            PrettyTextField(
                text: $enteredNewPassword,
                color: .lighterBrown,
                isSystemImage: true,
                image: "lock",
                width: nil,
                focusState: $focusedField,
                focusedValue: .newPassword
            )
            .background(.white, in: RoundedRectangle(cornerRadius: .Constants.elementCornerRadius))
            
            Text("Confirm new password")
                .font(.main(size: 16))
                .foregroundColor(.defaultBrown)
            PrettyTextField(
                text: $enteredNewPasswordConfirm,
                color: .lighterBrown,
                isSystemImage: true,
                image: "lock.rotation",
                width: nil,
                focusState: $focusedField,
                focusedValue: .newPasswordConfirm
            )
            .background(.white, in: RoundedRectangle(cornerRadius: .Constants.elementCornerRadius))
            //TODO: better validation
            PrettyButton(text: "Change Password", unactiveColor: .red , isActive: newPasswordsValidated) {
                Task {
                    await authenticationManager.updatePassword(to: enteredNewPassword)
                }
            }
            .disabled(!newPasswordsValidated)
            .frame(height: .Constants.lineElementHeight)
            .padding(.top, .Constants.standardSpacing)
            Spacer(minLength: 0)
        }
    }
}

#Preview {
    @State var isChangingPassword =  true
    return Color.red
        .sheet(isPresented: $isChangingPassword) {
            if #available(iOS 16.0, *) {
                PasswordChangeView<AuthenticationManagerStub>()
                    .presentationDetents([.medium])
            } else {
                // Fallback on earlier versions
            }
        }
}
