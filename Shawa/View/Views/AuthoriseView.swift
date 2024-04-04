//
//  AuthoriseView.swift
//  Shawa
//
//  Created by Alex on 10.03.23.
//

import SwiftUI
import ActionButton

fileprivate struct DrawingConstants {
    static let borderWidth: CGFloat = 1
    static let moveAnimtionTime: Double = 1
    static let elementsCornerRadius: CGFloat = 10
}

struct AuthoriseView<AuthenticationManagerType :AuthenticationManager>: View {
    @EnvironmentObject private var authenticationManager: AuthenticationManagerType
    
    @State private var enteredEmail = ""
    @State private var enteredPassword = ""
    @State private var enteredPasswordConfirm = ""
    @State private var currentAuthenticationFlow = AuthenticationFlow.login
    @FocusState private var focusedField: FocusableField?
    
    enum AuthenticationFlow {
        case login
        case register
    }
    
    private enum FocusableField: Hashable {
        case email, password, confirmPassword;
    }
    
    private var loginButtonState: ActionButton.State {
        switch authenticationManager.auth.state {
        case .notAuthenticated:
            if let error = authenticationManager.auth.currentError {
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
    
    var body: some View {
        ZStack(alignment: .top){
            backgroundBody
            contentBody
        }.preferredColorScheme(.dark)
    }
    
    var backgroundBody: some View {
        ZStack {
            Image("LoginBackgroundImage")
                .frame(width: 100, height: 100) //MARK: bogus??
                .ignoresSafeArea(.all)
            Rectangle()
                .foregroundStyle(LinearGradient(colors: [.deafultBrown,.clear], startPoint: .top, endPoint: .bottom))
                .ignoresSafeArea(.all)
        }
    }
    
    var contentBody: some View {
        VStack(alignment: .center){
            Text("Shawa")
                .frame(width: 172, height: 67, alignment: .center)
                .padding(.top, 50.0)
                .font(.logo(size: 50))
                .foregroundColor(.white)
            Text("We deliver it hot!")
                .font(.logo(size: 16))
                .frame(width: 172, height: 20, alignment: .center)
                .foregroundColor(.white)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 30).foregroundColor(.white)
                VStack(alignment: .center) {
                    Text("Authorise")
                        .frame(width: 307, alignment: .leading)
                        .font(.montserratBold(size: 24))
                        .padding(.all, 24)
                        .foregroundColor(.deafultBrown)
                    authoriseSwitchBody
                    if #available(iOS 16.0, *) {
                        Form {
                            authoriseContentBody
                        }
                            .formStyle(.columns)
                            .frame(width: 326, height: currentAuthenticationFlow == .register ? 260 : 190, alignment: .top)
                            .padding(.top, 25)
                    } else {
                        VStack {
                            authoriseContentBody
                        }
                            .frame(width: 326, height: currentAuthenticationFlow == .register ? 260 : 190, alignment: .top)
                            .padding(.top, 25)
                    }
                    
                }.frame(width: 355)
            }
                .frame(width: 355, height: currentAuthenticationFlow == .register ? 470 : 400)
                .padding(.top, 75)
        }
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
        ).padding(.top, 20)
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
            .padding(.top, 20)
            .transition(.offset(x: 0, y: -80).combined(with: .asymmetric(
                insertion: .opacity.animation(.linear(duration: 0.4 * DrawingConstants.moveAnimtionTime).delay(0.6 * DrawingConstants.moveAnimtionTime)),
                removal: .opacity.animation(.linear(duration: 0.4 * DrawingConstants.moveAnimtionTime))
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
        }.padding(.top, 20)
    }
    
    var authoriseSwitchBody: some View{
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: DrawingConstants.elementsCornerRadius)
                .strokeBorder(lineWidth: DrawingConstants.borderWidth)
                .frame(width: 326, height: 50)
                .padding(.leading, 3)
                .foregroundColor(.deafultBrown)
            RoundedRectangle(cornerRadius: DrawingConstants.elementsCornerRadius)
                .foregroundColor(.primaryBrown)
                .frame(width: 169, height: 56)
                .padding(.leading, currentAuthenticationFlow == .register ? 166 : 0)
            HStack() {
                Button("Log In") {
                    withAnimation(Animation.spring(response: DrawingConstants.moveAnimtionTime, dampingFraction: 0.7)) {
                        currentAuthenticationFlow = .login
                    }
                }
                .frame(width: 160, height: 56)
                .font(.mainBold(size: 16))
                .foregroundColor(currentAuthenticationFlow == .register ? .deafultBrown : .white)
                Button("Sign Up") {
                    withAnimation(Animation.spring(response: DrawingConstants.moveAnimtionTime, dampingFraction: 0.7)) {
                        currentAuthenticationFlow = .register
                    }
                }
                .frame(width: 161, height: 56)
                .font(.main(size: 16))
                .foregroundColor(currentAuthenticationFlow == .register ? .white : .deafultBrown)
            }
        }
        .frame(width:332, height: 56, alignment: .center)
    }
}

#Preview {
    @ObservedObject var am = AuthenticationManagerStub()
    am.logout()
    
    return AuthoriseView<AuthenticationManagerStub>()
        .environmentObject(am)
}
