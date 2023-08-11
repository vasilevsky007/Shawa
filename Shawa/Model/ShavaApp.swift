//
//  ShavaApp.swift
//  Shawa
//
//  Created by Alex on 10.03.23.
//

import Foundation
import Firebase
import FirebaseAuth
struct ShavaApp {
    enum AuthenticationState {
        case notAuthenticated
        case authenticated
        case inProgress
    }
    
    enum AuthenticationFlow {
        case login
        case register
    }
    
    enum FetchState {
        case done
        case failed
        case fetching
    }
    
    var currentAuthenticationState: AuthenticationState
    var currentAuthenticationFlow: AuthenticationFlow
    var menuFetchState: FetchState
    
    init(currentAuthenticationState: AuthenticationState = .notAuthenticated, currentAuthenticationFlow: AuthenticationFlow = .login, menuFetchState: FetchState = .done) {
        self.currentAuthenticationState = currentAuthenticationState
        self.currentAuthenticationFlow = currentAuthenticationFlow
        self.menuFetchState = menuFetchState
    }
}
