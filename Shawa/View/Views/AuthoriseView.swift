//
//  AuthoriseView.swift
//  Shawa
//
//  Created by Alex on 10.03.23.
//

import SwiftUI

struct AuthoriseView<AuthenticationManagerType :AuthenticationManager>: View {
    var isAdmin: Bool = false
    
    @EnvironmentObject private var authenticationManager: AuthenticationManagerType
    
    @State private var enteredEmail = ""
    @State private var enteredPassword = ""
    @State private var enteredPasswordConfirm = ""
    @State private var currentAuthenticationFlow = AuthenticationFlow.login
    @FocusState private var focusedField: FocusableField?
    
    private enum AuthenticationFlow {
        case login
        case register
    }
    
    private enum FocusableField: Hashable {
        case email, password, confirmPassword;
    }
    
    private var loginButtonState: ActionButton.State {
        switch authenticationManager.state {
        case .notAuthenticated:
            if let error = authenticationManager.currentError {
                .disabled(label: LocalizedStringKey(error.localizedDescription))
            } else {
                switch currentAuthenticationFlow {
                case .login:
                    .active(label: "Log in")
                case .register:
                    .active(label: "Register")
                }
            }
        case .authenticated:
                .disabled(label: "")
        case .inProgress:
            switch currentAuthenticationFlow {
            case .login:
                .loading(label: "Logging in")
            case .register:
                .loading(label: "Registering")
            }
        }
    }
    
    private let moveAnimtionTime: Double = 1
    private var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
    
    
    var body: some View {
        VStack(spacing: 0){
            Spacer(minLength: 0)
            contentBody
            Spacer(minLength: 0)
        }
            .background {
                backgroundBody
            }
            .ignoresSafeArea(.container)
            .animation(.default, value: focusedField)
    }
    
    private var backgroundBody: some View {
        ZStack {
            Image(.loginBackground)
                .fillWithoutStretch()
            Rectangle()
                .foregroundStyle(LinearGradient(colors: [.defaultBrownUnchangable, .clear], startPoint: .top, endPoint: .bottom))
        }
    }
    
    private var contentBody: some View {
        VStack(alignment: .center, spacing: 0){
            if (!isPhone || focusedField == nil) {
                logoBody
                    .padding(.vertical, .Constants.AuthoriseView.logoPadding)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Authorise")
                    .font(.montserratBold(size: 24))
                    .padding(.vertical, .Constants.tripleSpacing)
                    .foregroundColor(.defaultBrown)
                authoriseSwitchBody
                if #available(iOS 16.0, *) {
                    Form {
                        authoriseContentBody
                    }
                    .formStyle(.columns)
                    .padding(.vertical, .Constants.tripleSpacing)
                    .padding(.horizontal, .Constants.AuthoriseView.Switch.bouncerInset)
                } else {
                    VStack {
                        authoriseContentBody
                    }
                    .padding(.vertical, .Constants.tripleSpacing)
                    .padding(.horizontal, .Constants.AuthoriseView.Switch.bouncerInset)
                }
                
            }.padding(.horizontal, .Constants.doubleSpacing)
                .background(.background, in: .rect(cornerRadius: .Constants.blockCornerRadius))
            .padding(.horizontal, isPhone ? .Constants.doubleSpacing : 0)
            .frame(width: isPhone ? nil : .Constants.AuthoriseView.padFormWidth)
                
        }
    }
    
    var logoBody: some View {
        VStack(alignment: .center) {
            Text("Shawa")
                .font(.logo(size: 50))
                .foregroundColor(.white)
            Text(isAdmin ? "Administator App" : "We deliver it hot!")
                .font(.logo(size: 16))
                .foregroundColor(.white)
        }
    }
    
    var authoriseSwitchBody: some View{
        GeometryReader { geometry in
            let buttonWidth = geometry.size.width / 2
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: .Constants.elementCornerRadius)
                    .strokeBorder(lineWidth: .Constants.borderWidth)
                    .frame(
                        width: (buttonWidth - .Constants.AuthoriseView.Switch.bouncerInset) * 2,
                        height: .Constants.lineElementHeight
                    )
                    .padding(.horizontal, .Constants.AuthoriseView.Switch.bouncerInset)
                    .foregroundColor(.defaultBrown)
                
                RoundedRectangle(cornerRadius: .Constants.elementCornerRadius)
                    .foregroundColor(.primaryBrown)
                    .frame(width: buttonWidth, height: .Constants.AuthoriseView.Switch.bouncerHeight)
                    .padding(.leading, currentAuthenticationFlow == .register ? buttonWidth - .Constants.AuthoriseView.Switch.bouncerInset : 0)
                
                HStack(spacing: 0) {
                    Button{
                        withAnimation(Animation.spring(response: moveAnimtionTime, dampingFraction: 0.7)) {
                            currentAuthenticationFlow = .login
                        }
                    } label: {
                        Text("Log In")
                            .frame(width: buttonWidth, height: .Constants.AuthoriseView.Switch.bouncerHeight)
                            .font(currentAuthenticationFlow == .login ? .mainBold(size: 16) : .main(size: 16))
                            .foregroundColor(currentAuthenticationFlow == .login ? .white : .defaultBrown)
                    }
                    Button{
                        withAnimation(Animation.spring(response: moveAnimtionTime, dampingFraction: 0.7)) {
                            currentAuthenticationFlow = .register
                        }
                    } label: {
                        Text("Sign Up")
                            .frame(width: buttonWidth, height: .Constants.AuthoriseView.Switch.bouncerHeight)
                            .font(currentAuthenticationFlow == .register ? .mainBold(size: 16) : .main(size: 16))
                            .foregroundColor(currentAuthenticationFlow == .register ? .white : .defaultBrown)
                    }
                    
                }
            }
        }.frame(height: .Constants.AuthoriseView.Switch.bouncerHeight, alignment: .center)
    }
    
    @ViewBuilder
    var authoriseContentBody: some View {
        PrettyTextField(
            text: $enteredEmail,
            label: "Email",
            color: .lighterBrown,
            image: "MailIcon",
            focusState: $focusedField,
            focusedValue: .email,
            keyboardType: .emailAddress) {
                focusedField = .password
            }
        PrettyTextField(
            text: $enteredPassword,
            label: "Password",
            isSecured: true,
            color: .lighterBrown,
            image: "LockIcon",
            focusState: $focusedField,
            focusedValue: .password,
            submitLabel: currentAuthenticationFlow == .register ? .next : .done,
            submitAction: currentAuthenticationFlow == .register ? { focusedField = .confirmPassword } : nil
        ).padding(.top, .Constants.doubleSpacing)
        if currentAuthenticationFlow == .register {
            PrettyTextField(
                text: $enteredPasswordConfirm,
                label: "Confirm Password",
                isSecured: true,
                color: .lighterBrown,
                image: "LockIcon",
                focusState: $focusedField,
                focusedValue: .confirmPassword,
                submitLabel: .done)
            .padding(.top, .Constants.doubleSpacing)
            .transition(
                .offset(x: 0, y: -(.Constants.lineElementHeight + .Constants.doubleSpacing))
                .combined(with: .asymmetric(
                    insertion: .opacity
                        .animation(.easeIn(duration: 0.3 * moveAnimtionTime).delay(0.7 * moveAnimtionTime)),
                    removal: .opacity
                        .animation(.easeOut(duration: 0.3 * moveAnimtionTime))
            )))
        }
        ActionButton(state: loginButtonState, disabledColor: .red) {
            switch currentAuthenticationFlow {
            case .login:
                Task {
                    await authenticationManager.login(withEmail: enteredEmail, password: enteredPassword)
                }
            case .register:
                Task {
                    await authenticationManager.register(withEmail: enteredEmail, password: enteredPassword)
                }
            }
        }.padding(.top, .Constants.doubleSpacing)
    }
}

#Preview {
    @ObservedObject var am = AuthenticationManagerStub()
    am.logout()
    
    return AuthoriseView<AuthenticationManagerStub>()
        .environmentObject(am)
}
