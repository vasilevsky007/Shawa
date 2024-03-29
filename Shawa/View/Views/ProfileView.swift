//
//  ProfileView.swift
//  Shawa
//
//  Created by Alex on 22.09.23.
//

import SwiftUI
import ActionButton
import FirebaseAuth

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @GestureState private var dragOffset = CGSize.zero
    @EnvironmentObject var firebase: Firebase
    
    private enum FocusableField: Hashable {
        case name, comment;
    }
    
    @FocusState private var focusedField: FocusableField?
    
    @State private var isChangingPassword = false
    @State private var isShowingDeleteAlert = false
    
    @State private var enteredName = ""
    @State private var enteredEmail = ""
    //    @State private var enteredPhone = ""
    @State private var errorDescription: String? = nil
    
    @State private var isEditingName = false
    @State private var isEditingEmail = false
    @State private var isEditingPhone = false
    
    func loadUserInfo() {
        enteredName = firebase.currentUser?.displayName ?? ""
        enteredEmail = firebase.currentUser?.email ?? ""
        //                enteredPhone = firebase.currentUser?.phoneNumber ?? ""
    }
    
    func showErrorDescription(_ description: String?) async {
        errorDescription = description
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        if errorDescription == description {
            errorDescription = nil
        }
    }
    
    func updateEmail() {
        Task.detached {
            do {
                try await firebase.updateEmail(to: enteredEmail)
            } catch {
                await loadUserInfo()
                await showErrorDescription("Error updating E-mail: " + error.localizedDescription)
            }
        }
    }
    
    func deleteAccount() {
        Task.detached {
            do {
                try await firebase.deleteAccount()
            } catch {
                await showErrorDescription("Error deleting account: " + error.localizedDescription)
            }
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
        Task.detached {
            do {
                try await firebase.updateName(to: enteredName)
            } catch {
                await showErrorDescription("Error updating name: " + error.localizedDescription)
            }
        }
    }
    
    func closeThisView () {
        dismiss()
    }
    
    private struct DrawingConstants {
        static let gridSpacing: CGFloat = 16
        static let pagePadding: CGFloat = 24
        static let padding: CGFloat = 8
        static let cornerRadius: CGFloat = 30
        static let headlineFontSize: CGFloat = 24
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
                }.padding(.horizontal, 24.5)
                
                Text("Profile")
                    .foregroundColor(.deafultBrown)
                    .font(.montserratBold(size: 24))
                    .padding(.horizontal, DrawingConstants.pagePadding)
                    .padding(.top, DrawingConstants.padding)
                ZStack {
                    RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                        .ignoresSafeArea(edges: .bottom)
                        .foregroundColor(.veryLightBrown2)
                    VStack (alignment: .leading, spacing: 8) {
                        Text("Name")
                            .font(.main(size: 16))
                            .foregroundColor(.deafultBrown)
                        conditionalTextEditor(isEditing: $isEditingName, value: $enteredName, systemImage: "person") {
                            updateName()
                        }
                        Text("E-mail")
                            .font(.main(size: 16))
                            .foregroundColor(.deafultBrown)
                        conditionalTextEditor(isEditing: $isEditingEmail, value: $enteredEmail, systemImage: "envelope") {
                            updateEmail()
                        }
                        //                        Text("Phone number")
                        //                            .font(.main(size: 16))
                        //                            .foregroundColor(.deafultBrown)
                        //                        conditionalTextEditor(isEditing: $isEditingPhone, value: $enteredPhone, systemImage: "phone.down")
                        PrettyButton(text: "Change Password", isActive: true) {
                            isChangingPassword = true
                        }
                        .frame(height: 50)
                        .padding(.top, 8)
                        .sheet(isPresented: $isChangingPassword) {
                            PasswordChangeView()
//                                FIXME: .presentationDetents([.medium])
//                                .presentationBackground(Color.veryLightBrown)
//                                .presentationCornerRadius(DrawingConstants.cornerRadius)
                        }
                        PrettyButton(text: "Delete your account", color: .red , isActive: true) {
                            isShowingDeleteAlert = true
                        }
                        .frame(height: 50)
                        .padding(.top, 8)
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
                                    .padding(.all, DrawingConstants.padding)
                                    .frame(minWidth: geometry.size.width, minHeight: 50)
                                    .background {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(lineWidth: 1)
                                            .foregroundColor(.red)
                                    }
                            }.padding(.top, 8)
                        }
                        Spacer(minLength: 0)
                    }.padding(DrawingConstants.pagePadding)
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

struct ProfileView_Previews: PreviewProvider {
    static var app = ShavaAppSwiftUI()
    static var fire = Firebase(app: app)
    static var previews: some View {
        return ProfileView()
            .environmentObject(app)
            .previewDevice("iPhone 11 Pro")
    }
}
