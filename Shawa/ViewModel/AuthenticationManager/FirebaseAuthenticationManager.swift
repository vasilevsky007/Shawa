//
//  FirebaseAuthenticationManager.swift
//  Shawa
//
//  Created by Alex on 30.03.24.
//

import SwiftUI

@MainActor
class FirebaseAuthenticationManager: AuthenticationManager {
    @Published private(set) var auth: Authentication = FirebaseAuthentication()
    
    @Published private var isAuthenticating = false
    @Published private (set) var isEditing = false
    @Published private (set) var currentError: Error?
    
    var state: AuthenticationState {
        if auth.uid != nil {
            return .authenticated
        } else {
            if isAuthenticating {
                return .inProgress
            } else {
                return .notAuthenticated
            }
        }
    }
    
    func register(withEmail email: String, password: String) async {
        do {
            withAnimation {
                isAuthenticating = true
                clearError()
            }
            try await self.auth.register(withEmail: email, password: password)
            withAnimation {
                isAuthenticating = false
            }
        } catch {
            withAnimation {
                currentError = error
                isAuthenticating = false
            }
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            clearError()
        }
    }
    
    func login(withEmail email: String, password: String) async {
        do {
            withAnimation {
                isAuthenticating = true
                clearError()
            }
            try await auth.login(withEmail: email, password: password)
            withAnimation {
                isAuthenticating = false
            }
        } catch {
            withAnimation {
                currentError = error
                isAuthenticating = false
            }
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            clearError()
        }
    }
    
    func logout() {
        Task {
            do {
                withAnimation {
                    clearError()
                }
                try auth.logout()
            } catch {
                withAnimation {
                    currentError = error
                }
                try? await Task.sleep(nanoseconds: 5_000_000_000)
                withAnimation {
                    clearError()
                }
            }
        }
    }
    
    func deleteAccount() async {
        do {
            withAnimation {
                clearError()
                isEditing = true
            }
            try await auth.deleteAccount()
            withAnimation {
                isEditing = false
            }
        } catch {
            withAnimation {
                currentError = error
                isEditing = false
            }
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            clearError()
        }
    }
    
    func updateEmail(to email: String) async {
        do {
            withAnimation {
                clearError()
                isEditing = true
            }
            try await auth.updateEmail(to: email)
            withAnimation {
                isEditing = false
            }
        } catch {
            withAnimation {
                currentError = error
                isEditing = false
            }
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            clearError()
        }
    }
    
    func updateName(to name: String) async {
        do {
            withAnimation {
                clearError()
                isEditing = true
            }
            try await auth.updateName(to: name)
            withAnimation {
                isEditing = false
            }
        } catch {
            withAnimation {
                currentError = error
                isEditing = false
            }
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            clearError()
        }
    }
    
    func updatePassword(to password: String) async {
        
        do {
            withAnimation {
                clearError()
                isEditing = true
            }
            try await auth.updatePassword(to: password)
            withAnimation {
                isEditing = false
            }
        } catch {
            withAnimation {
                currentError = error
                isEditing = false
            }
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            clearError()
        }
    }
    
    func clearError() {
        withAnimation {
            currentError = nil
        }
    }
}
