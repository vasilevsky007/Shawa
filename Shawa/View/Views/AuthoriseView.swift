//
//  AuthoriseView.swift
//  Shawa
//
//  Created by Alex on 10.03.23.
//

import SwiftUI
import ActionButton

struct AuthoriseView: View {
    
    @EnvironmentObject var app: ShavaAppSwiftUI
    @EnvironmentObject var firebase: Firebase
    
    @State private var enteredEmail = ""
    @State private var enteredPassword = ""
    @State private var enteredPasswordConfirm = ""
    
    private enum FocusableField: Hashable {
        case email, password, confirmPassword;
    }
    @FocusState private var focusedField: FocusableField?
    
    
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
            
            authoriseBody
                .padding(.top, 75)
        }
    }
    
    var authoriseBody: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 30).foregroundColor(.white)
            VStack(alignment: .center) {
                Text("Authorise")
                    .frame(width: 307, alignment: .leading)
                    .font(.montserratBold(size: 24))
                    .padding(.all, 24)
                    .foregroundColor(.deafultBrown)
                authoriseSwitchBody
                Form {
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
                        submitLabel: app.isRegistering ? .next : .done,
                        submitAction: app.isRegistering ? { focusedField = .confirmPassword } : nil
                    ).padding(.top, 20)
                    if app.isRegistering {
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
                    ActionButton(state: $app.loginButtonState, onTap: {
                        app.loginButtonState = .loading(title: "Loading", systemImage: "")
                        if app.isRegistering {
                            Task(priority: .userInitiated) {
                                await firebase.register(email: enteredEmail, password: enteredPassword)
                            }
                        } else {
                            Task(priority: .userInitiated) {
                                await firebase.login(email: enteredEmail, password: enteredPassword)
                            }

                        }
                    }, backgroundColor: .primaryBrown, foregroundColor: .white)
                    .padding(.top, 20)
                }
                    .formStyle(.columns)
                    .frame(width: 326, height: app.isRegistering ? 260 : 190, alignment: .top)
                    .padding(.top, 25)
                
            }
            .frame(width: 355)
        }
        .frame(width: 355, height: app.isRegistering ? 470 : 400)
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
                .padding(.leading, app.isRegistering ? 166 : 0)
            HStack() {
                Button("Log In") {
                    withAnimation(Animation.spring(response: DrawingConstants.moveAnimtionTime, dampingFraction: 0.7)) {
                        app.switchToLogin()
                    }
                }
                .frame(width: 160, height: 56)
                .font(.mainBold(size: 16))
                .foregroundColor(app.isRegistering ? .deafultBrown : .white)
                Button("Sign Up") {
                    withAnimation(Animation.spring(response: DrawingConstants.moveAnimtionTime, dampingFraction: 0.7)) {
                        app.switchToRegistration()
                    }
                }
                .frame(width: 161, height: 56)
                .font(.main(size: 16))
                .foregroundColor(app.isRegistering ? .white : .deafultBrown)
            }
        }
        .frame(width:332, height: 56, alignment: .center)
    }
    
    struct DrawingConstants {
        static let borderWidth: CGFloat = 1
        static let moveAnimtionTime: Double = 1
        static let elementsCornerRadius: CGFloat = 10
    }
}



