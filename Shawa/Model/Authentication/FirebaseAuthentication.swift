//
//  FirebaseAuthentication.swift
//  Shawa
//
//  Created by Alex on 29.03.24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct FirebaseAuthentication: Authentication {
    private var currentUser: User?
    
    var uid: String? {
        currentUser?.uid
    }
    
    var name: String? {
        currentUser?.displayName
    }
        
    var email: String? {
        currentUser?.email
    }
        
    var phone: String? {
        currentUser?.phoneNumber
    }
    
    var state: AuthenticationState {
        if currentUser != nil {
            return .authenticated
        } else {
            if isAuthenticating {
                return .inProgress
            } else {
                return .notAuthenticated
            }
        }
    }
    
    private var isAuthenticating: Bool
    
    private (set) var isEditing: Bool
    
    private (set) var currentError: Error?
    
    
    init() {
        currentUser = Auth.auth().currentUser
        isAuthenticating = false
        isEditing = false
    }
    
    @MainActor mutating func register(withEmail email: String, password: String) async {
        do {
            withAnimation {
                isAuthenticating = true
                currentError = nil
            }
            let task = Task.detached {
                try await Auth.auth().createUser(withEmail: email, password: password)
            }
            let result = await task.result
            try withAnimation {
                currentUser = try result.get().user
                isAuthenticating = false
            }
        } catch {
            withAnimation {
                currentError = error
                isAuthenticating = false
            }
        }
    }
    
    @MainActor mutating func login(withEmail email: String, password: String) async {
        do {
            withAnimation {
                isAuthenticating = true
                currentError = nil
            }
            let task = Task.detached {
                try await Auth.auth().signIn(withEmail: email, password: password)
            }
            let result = await task.result
            try withAnimation {
                currentUser = try result.get().user
                isAuthenticating = false
            }
        } catch {
            withAnimation {
                currentError = error
                isAuthenticating = false
            }
        }
    }
    
    @MainActor mutating func logout() {
        do {
            try withAnimation {
                currentError = nil
                try Auth.auth().signOut()
                currentUser = Auth.auth().currentUser
            }
        } catch {
            withAnimation {
                currentError = error
            }
        }
    }
    
    @MainActor mutating func deleteAccount() async {
        do {
            withAnimation {
                currentError = nil
                isEditing = true
            }
            let task = Task.detached {
                try await Auth.auth().currentUser?.delete()
            }
            try await task.result.get()
            withAnimation {
                currentUser = Auth.auth().currentUser
                isEditing = false
            }
        } catch {
            withAnimation {
                currentError = error
                isEditing = false
                currentUser = Auth.auth().currentUser
            }
        }
    }
    
    @MainActor mutating func updateEmail(to email: String) async {
        do {
            withAnimation {
                currentError = nil
                isEditing = true
            }
            let task = Task.detached {
                try await Auth.auth().currentUser?.sendEmailVerification(beforeUpdatingEmail: email)
            }
            try await task.result.get()
            withAnimation {
                currentUser = Auth.auth().currentUser
                isEditing = false
            }
        } catch {
            withAnimation {
                currentError = error
                isEditing = false
                currentUser = Auth.auth().currentUser
            }
        }
    }
    
    @MainActor mutating func updateName(to name: String) async {
        do {
            withAnimation {
                currentError = nil
                isEditing = true
            }
            let task = Task.detached {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = name
                try await changeRequest?.commitChanges()
            }
            try await task.result.get()
            withAnimation {
                currentUser = Auth.auth().currentUser
                isEditing = false
            }
        } catch {
            withAnimation {
                currentError = error
                isEditing = false
                currentUser = Auth.auth().currentUser
            }
        }
    }
    
    @MainActor mutating func updatePassword(to password: String) async {
        do {
            withAnimation {
                currentError = nil
                isEditing = true
            }
            let task = Task.detached {
                try await Auth.auth().currentUser?.updatePassword(to: password)
            }
            try await task.result.get()
            withAnimation {
                currentUser = Auth.auth().currentUser
                isEditing = false
            }
        } catch {
            withAnimation {
                currentError = error
                isEditing = false
                currentUser = Auth.auth().currentUser
            }
        }
    }
    
    @MainActor mutating func clearError() {
        withAnimation {
            currentError = nil
        }
    }
}
