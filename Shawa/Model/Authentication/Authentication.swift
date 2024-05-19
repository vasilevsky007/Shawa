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
    
    mutating func register(withEmail email: String, password: String) async throws
    mutating func login(withEmail email: String, password: String) async throws
    mutating func logout() throws
    mutating func deleteAccount() async throws
    mutating func updateEmail(to email: String) async throws
    mutating func updateName(to name: String) async throws
    mutating func updatePassword(to password: String) async throws
}
