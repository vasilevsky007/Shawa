//
//  ProfileView.swift
//  Shawa
//
//  Created by Alex on 22.09.23.
//

import SwiftUI
import FirebaseAuth


struct ProfileView<AuthenticationManagerType: AuthenticationManager>: View {
    @EnvironmentObject private var authenticationManager: AuthenticationManagerType
    
    @Environment(\.dismiss) private var dismiss
    @GestureState private var dragOffset = CGSize.zero
    
    private enum FocusableField: Hashable {
        case name, comment;
    }
    
    @FocusState private var focusedField: FocusableField?
    
    @State private var isChangingPassword = false
    @State private var isShowingDeleteAlert = false
    
    @State private var enteredName = ""
    @State private var enteredEmail = ""
    //    @State private var enteredPhone = ""
    private var errorDescription: String? {
        authenticationManager.auth.currentError?.localizedDescription
    }
    
    @State private var isEditingName = false
    @State private var isEditingEmail = false
    @State private var isEditingPhone = false
    
    func loadUserInfo() {
        enteredName = authenticationManager.auth.name ?? ""
        enteredEmail = authenticationManager.auth.email ?? ""
        //                enteredPhone = firebase.currentUser?.phoneNumber ?? ""
    }
    
    func updateEmail() {
        Task {
            await authenticationManager.updateEmail(to: enteredEmail)
            loadUserInfo()
        }
    }
    
    func deleteAccount() {
        Task {
            await authenticationManager.deleteAccount()
        }
    }
    
    //    func updatePhone() {
    //        Task.detached {
    //            do {
    //                try await firebase.currentUser?.updatePhoneNumber(enteredPhone)
    //            } catch {
    //                await showErrorDescription("Error updating E-mail: " + error.localizedDescription)
    //            }
    //        }
    //    }
    
    func updateName() {
        Task {
            await authenticationManager.updateName(to: enteredName)
        }
    }
    
    func closeThisView () {
        dismiss()
    }
    
    var backgroundBody: some View {
        Rectangle()
            .ignoresSafeArea()
            .foregroundColor(.white)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            backgroundBody
            VStack(alignment: .leading) {
                Header(leadingIcon: "BackIcon", leadingAction: {
                    closeThisView()
                }, noTrailingLink: true) {
                    Text("placeholder. will not be seen")
                }.padding(.horizontal, .Constants.horizontalSafeArea)
                
                Text("Profile")
                    .foregroundColor(.deafultBrown)
                    .font(.montserratBold(size: 24))
                    .padding(.horizontal, .Constants.horizontalSafeArea)
                    .padding(.top, .Constants.standardSpacing)
                ZStack {
                    RoundedRectangle(cornerRadius: .Constants.blockCornerRadius)
                        .ignoresSafeArea(edges: .bottom)
                        .foregroundColor(.veryLightBrown2)
                    VStack (alignment: .leading, spacing: .Constants.standardSpacing) {
                        Text("Name")
                            .font(.main(size: 16))
                            .foregroundColor(.deafultBrown)
                        ConditionalTextEditor(isEditing: $isEditingName, value: $enteredName, systemImage: "person") {
                            updateName()
                        }
                        Text("E-mail")
                            .font(.main(size: 16))
                            .foregroundColor(.deafultBrown)
                        ConditionalTextEditor(isEditing: $isEditingEmail, value: $enteredEmail, systemImage: "envelope") {
                            updateEmail()
                        }
                        //                        Text("Phone number")
                        //                            .font(.main(size: 16))
                        //                            .foregroundColor(.deafultBrown)
                        //                        conditionalTextEditor(isEditing: $isEditingPhone, value: $enteredPhone, systemImage: "phone.down")
                        PrettyButton(text: "Change Password", isActive: true) {
                            isChangingPassword = true
                        }
                        .frame(height: .Constants.lineElementHeight)
                        .padding(.top, .Constants.standardSpacing)
                        .sheet(isPresented: $isChangingPassword) {
                            if #available(iOS 16.0, *) {
                                if #available(iOS 16.4, *) {
                                    PasswordChangeView<AuthenticationManagerType>(background: .veryLightBrown)
                                        .presentationDetents([.medium])
                                        .presentationCornerRadius(.Constants.blockCornerRadius)
                                } else {
                                    PasswordChangeView<AuthenticationManagerType>(background: .veryLightBrown)
                                        .presentationDetents([.medium])
                                }
                            } else {
                                PasswordChangeView<AuthenticationManagerType>(background: .veryLightBrown)
                            }

                        }
                        PrettyButton(text: "Delete your account", color: .red , isActive: true) {
                            isShowingDeleteAlert = true
                        }
                        .frame(height: .Constants.lineElementHeight)
                        .padding(.top, .Constants.standardSpacing)
                        .alert("Confirm deleting", isPresented: $isShowingDeleteAlert) {
                            Button("Yes", role: .destructive) {
                                deleteAccount()
                            }
                            Button("No", role: .cancel) {
                                
                            }
                        } message: {
                            Text("Are you sure You want to delete your account? (This change can't be reverted)")
                        }
                        if let errorDescriptionUnwrapped = errorDescription {
                            GeometryReader { geometry in
                                Text(errorDescriptionUnwrapped)
                                    .font(.main(size: 16))
                                    .foregroundColor(.red)
                                    .padding(.all, .Constants.standardSpacing)
                                    .frame(minWidth: geometry.size.width, minHeight: .Constants.lineElementHeight)
                                    .background {
                                        RoundedRectangle(cornerRadius: .Constants.elementCornerRadius)
                                            .stroke(lineWidth: .Constants.borderWidth)
                                            .foregroundColor(.red)
                                    }
                            }.padding(.top, .Constants.standardSpacing)
                        }
                        Spacer(minLength: 0)
                    }.padding(.Constants.horizontalSafeArea)
                }.ignoresSafeArea( .container)
            }
            
        }
        //FIXME: .scrollDismissesKeyboard(.interactively)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            
        }
        .highPriorityGesture(DragGesture().updating($dragOffset, body: { (value, _, _) in
            if(value.startLocation.x < 50 && value.translation.width > 100) {
                closeThisView()
            }
        }))
        .task {
            loadUserInfo()
        }
    }
}

#Preview {
    ProfileView<AuthenticationManagerStub>()
        .environmentObject(AuthenticationManagerStub())
}
