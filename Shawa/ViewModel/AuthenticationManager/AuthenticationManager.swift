//
//  AuthenticationManager.swift
//  Shawa
//
//  Created by Alex on 30.03.24.
//

import Foundation

@MainActor
protocol AuthenticationManager: ObservableObject {
    var auth: Authentication { get set }
}
