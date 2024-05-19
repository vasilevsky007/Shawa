//
//  AuthenticationManager.swift
//  Shawa
//
//  Created by Alex on 30.03.24.
//

import Foundation

@MainActor
protocol AuthenticationManager: ObservableObject {
    var auth: Authentication { get }
    
    var state: AuthenticationState { get }
    var isEditing: Bool { get }
    var currentError: Error? { get }
    
    func register(withEmail email: String, password: String) async
    func login(withEmail email: String, password: String) async
    func logout()
    func deleteAccount() async
    func updateEmail(to email: String) async
    func updateName(to name: String) async
    func updatePassword(to password: String) async
    func clearError()
}

enum AuthenticationState {
    case notAuthenticated
    case authenticated
    case inProgress
}
