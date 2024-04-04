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
    
    func register(withEmail email: String, password: String) async {
        await auth.register(withEmail: email, password: password)
    }
    
    func login(withEmail email: String, password: String) async {
        await auth.login(withEmail: email, password: password)
    }
    
    func logout() {
        auth.logout()
    }
    
    func deleteAccount() async {
        await auth.deleteAccount()
    }
    
    func updateEmail(to email: String) async {
        await auth.updateEmail(to: email)
    }
    
    func updateName(to name: String) async {
        await auth.updateName(to: name)
    }
    
    func updatePassword(to password: String) async {
        await auth.updatePassword(to: password)
    }
    
    func clearError() {
        auth.clearError()
    }
}
