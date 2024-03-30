//
//  FirebaseAuthentication.swift
//  Shawa
//
//  Created by Alex on 29.03.24.
//

import Foundation
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
    
    mutating func register(withEmail email: String, password: String) async {
        do {
            isAuthenticating = true
            currentError = nil
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            currentUser = result.user
            isAuthenticating = false
        } catch {
            currentError = error
            isAuthenticating = false
        }
    }
    
    mutating func login(withEmail email: String, password: String) async {
        do {
            isAuthenticating = true
            currentError = nil
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            currentUser = result.user
            isAuthenticating = false
        } catch {
            currentError = error
            isAuthenticating = false
        }
    }
    
    mutating func logout() {
        do {
            currentError = nil
            try Auth.auth().signOut()
            currentUser = Auth.auth().currentUser
        } catch {
            currentError = error
        }
    }
    
    mutating func deleteAccount() async {
        do {
            currentError = nil
            isEditing = true
            try await currentUser?.delete()
            currentUser = Auth.auth().currentUser
            isEditing = false
        } catch {
            currentError = error
            isEditing = false
            currentUser = Auth.auth().currentUser
        }
    }
    
    mutating func updateEmail(to email: String) async {
        do {
            currentError = nil
            isEditing = true
            try await currentUser?.sendEmailVerification(beforeUpdatingEmail: email)
            currentUser = Auth.auth().currentUser
            isEditing = false
        } catch {
            currentError = error
            isEditing = false
            currentUser = Auth.auth().currentUser
        }
    }
    
    mutating func updateName(to name: String) async {
        do {
            currentError = nil
            isEditing = true
            let changeRequest = currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = name
            try await changeRequest?.commitChanges()
            currentUser = Auth.auth().currentUser
            isEditing = false
        } catch {
            currentError = error
            isEditing = false
            currentUser = Auth.auth().currentUser
        }
    }
    
    mutating func clearError() {
        currentError = nil
    }
}
