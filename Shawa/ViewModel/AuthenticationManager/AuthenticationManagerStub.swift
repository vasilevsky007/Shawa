//
//  AuthenticationManagerStub.swift
//  Shawa
//
//  Created by Alex on 31.03.24.
//

import Foundation

@MainActor
class AuthenticationManagerStub: AuthenticationManager {
    var state: AuthenticationState = .notAuthenticated
    
    var isEditing: Bool = false
    
    var currentError: (any Error)?
    
    var auth: Authentication = AuthenticationStub()
    
    func register(withEmail email: String, password: String, confirmation: String) async {
        
    }
    
    func login(withEmail email: String, password: String) async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        try? await auth.login(withEmail: email, password: password)
    }
    
    func logout() {
        try? auth.logout()
    }
    
    func deleteAccount() async {
        
    }
    
    func updateEmail(to email: String) async {
        
    }
    
    func updateName(to name: String) async {
        
    }
    
    func updatePassword(to password: String) async {
        
    }
    
    func clearError() {
        
    }
}
