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
    
    init() {
        currentUser = Auth.auth().currentUser
    }
    
    @MainActor mutating func register(withEmail email: String, password: String) async throws {
        let task = Task.detached {
            try await Auth.auth().createUser(withEmail: email, password: password)
        }
        let result = try await task.result.get()
        currentUser = result.user
    }
    
    @MainActor mutating func login(withEmail email: String, password: String) async throws {
        let task = Task.detached {
            try await Auth.auth().signIn(withEmail: email, password: password)
        }
        let result = try await task.result.get()
        currentUser = result.user
    }
    
    @MainActor mutating func logout() throws {
        do {
            try withAnimation {
                try Auth.auth().signOut()
                currentUser = Auth.auth().currentUser
            }
        } catch {
            currentUser = Auth.auth().currentUser
            throw error
        }
    }
    
    @MainActor mutating func deleteAccount() async throws {
        do {
            let task = Task.detached {
                try await Auth.auth().currentUser?.delete()
            }
            try await task.result.get()
        } catch {
            withAnimation {
                currentUser = Auth.auth().currentUser
            }
            throw error
        }
    }
    
    @MainActor mutating func updateEmail(to email: String) async throws {
        do {
            let task = Task.detached {
                try await Auth.auth().currentUser?.sendEmailVerification(beforeUpdatingEmail: email)
            }
            try await task.result.get()
            currentUser = Auth.auth().currentUser
        } catch {
            withAnimation {
                currentUser = Auth.auth().currentUser
            }
            throw error
        }
    }
    
    @MainActor mutating func updateName(to name: String) async throws {
        do {
            let task = Task.detached {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = name
                try await changeRequest?.commitChanges()
            }
            try await task.result.get()
            withAnimation {
                currentUser = Auth.auth().currentUser
            }
        } catch {
            withAnimation {
                currentUser = Auth.auth().currentUser
            }
            throw error
        }
    }
    
    @MainActor mutating func updatePassword(to password: String) async throws {
        do {
            let task = Task.detached {
                try await Auth.auth().currentUser?.updatePassword(to: password)
            }
            try await task.result.get()
            withAnimation {
                currentUser = Auth.auth().currentUser
            }
        } catch {
            withAnimation {
                currentUser = Auth.auth().currentUser
            }
            throw error
        }
    }
}
