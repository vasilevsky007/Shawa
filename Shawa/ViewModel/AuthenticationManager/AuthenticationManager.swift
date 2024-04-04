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
    func register(withEmail email: String, password: String) async
    func login(withEmail email: String, password: String) async
    func logout()
    func deleteAccount() async
    func updateEmail(to email: String) async
    func updateName(to name: String) async
    func updatePassword(to password: String) async
    func clearError()
}
