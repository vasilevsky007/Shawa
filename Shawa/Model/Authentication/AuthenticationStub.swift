//
//  AuthenticationStub.swift
//  Shawa
//
//  Created by Alex on 31.03.24.
//

import Foundation

struct AuthenticationStub: Authentication {
    private(set) var uid: String?
    
    private(set) var name: String? = "user Name"
    
    private(set) var email: String? = "esd@email.com"
    
    private(set) var phone: String?
    
    private(set) var state: AuthenticationState = .authenticated
    
    private(set) var isEditing: Bool = false
    
    private(set) var currentError: Error? = nil
    
    mutating func register(withEmail email: String, password: String) async {
        state = .authenticated
    }
    
    mutating func login(withEmail email: String, password: String) async {
        state = .authenticated
    }
    
    mutating func logout() {
        state = .notAuthenticated
    }
    
    mutating func deleteAccount() async {
        
    }
    
    mutating func updateEmail(to email: String) async {
        
    }
    
    mutating func updateName(to name: String) async {
        
    }
    
    mutating func updatePassword(to password: String) async {
        
    }
    
    mutating func clearError() {
        
    }
    
    
}
