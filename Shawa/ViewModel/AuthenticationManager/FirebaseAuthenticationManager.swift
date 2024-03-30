//
//  FirebaseAuthenticationManager.swift
//  Shawa
//
//  Created by Alex on 30.03.24.
//

import Foundation

@MainActor
class FirebaseAuthenticationManager: AuthenticationManager {
    @Published var auth: Authentication = FirebaseAuthentication()
}
