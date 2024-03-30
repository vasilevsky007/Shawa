//
//  Authentication.swift
//  Shawa
//
//  Created by Alex on 30.03.24.
//

import Foundation

protocol Authentication {
    var uid: String? { get }
    var name: String? { get }
    var email: String? { get }
    var phone: String? { get }
    var state: AuthenticationState { get }
    var isEditing: Bool { get }
    var currentError: Error? { get }
    
    mutating func register(withEmail email: String, password: String) async
    mutating func login(withEmail email: String, password: String) async
    mutating func logout()
    mutating func deleteAccount() async
    mutating func updateEmail(to email: String) async
    mutating func updateName(to name: String) async
    mutating func clearError()
}

enum AuthenticationState {
    case notAuthenticated
    case authenticated
    case inProgress
}
