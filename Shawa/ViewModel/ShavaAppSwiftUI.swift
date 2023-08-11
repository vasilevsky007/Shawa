//
//  ShavaAppSwiftUI.swift
//  Shawa
//
//  Created by Alex on 10.03.23.
//

import SwiftUI
import ActionButton
import FirebaseAuth

@MainActor
class ShavaAppSwiftUI: ObservableObject {
    @Published var model = ShavaApp()
    @Published var menu = Menu()
    @Published private var currentOrder = Order()
    
    var isLoggedIn: Bool {
        if (model.currentAuthenticationState == .authenticated) {
            return true
        } else {
            return false
        }
    }

    var isRegistering: Bool {
        if (model.currentAuthenticationFlow == .register) {
            return true
        } else {
            return false
        }
    }
    
    var isFetchingMenu: Bool {
        if model.menuFetchState == .fetching {
            return true
        } else {
            return false
        }
    }
    
    var isCartEmpty: Bool {
        currentOrder.orderItems.isEmpty
    }
    
    var numberOfItemsInCart: Int {
        var numberOfItems = 0;
        for orderItem in currentOrder.orderItems {
            numberOfItems += orderItem.value
        }
        return numberOfItems;
    }
    
    var cartItems: [Order.Item:Int] {
        currentOrder.orderItems
    }
    
    func clearMenu() {
        withAnimation {
            menu.clearMenu()
        }
    }
    
    func addMenuItem(_ item: Menu.Item?) {
        if (item != nil) {
            withAnimation {
                menu.addItem(item!)
            }
        }
    }
    
    func switchToRegistration() {
        model.currentAuthenticationFlow = .register
        loginButtonState = .enabled(title: "Register", systemImage: "")
    }
    
    func startRegistration() {
        model.currentAuthenticationState = .inProgress
        loginButtonState = .loading(title: "Registering", systemImage: "")
    }
    
    func switchToLogin(){
        model.currentAuthenticationFlow = .login
        loginButtonState = .enabled(title: "Log In", systemImage: "")
    }
    
    func startLogin() {
        model.currentAuthenticationState = .inProgress
        loginButtonState = .loading(title: "Logging in", systemImage: "")
    }
    
    func authenticationSuccess(userInfo: User) {
        print("authsuccess1")
        model.currentAuthenticationState = .authenticated
        //TODO: save user
    }
    
    func authenticationFailure(reason error: String) {
        print("authfailure1")
        model.currentAuthenticationState = .notAuthenticated
        loginButtonState = .enabled(title: error, systemImage: "exclamationmark.circle")
        DispatchQueue.main.schedule(after: .init(.now()).advanced(by: .seconds(5.0)), {
            self.loginButtonState = .enabled(title: self.model.currentAuthenticationFlow == .login ? "Log In" : "Register", systemImage: "")
        })
    }
    
    func initialAuthenticationFailure() {
        print("init_authfailure1")
        model.currentAuthenticationState = .notAuthenticated
        loginButtonState = .enabled(title: model.currentAuthenticationFlow == .login ? "Log In" : "Register", systemImage: "")
    }
    
    func startFetchingMenu() {
        withAnimation {
            model.menuFetchState = .fetching
        }
        
    }
    
    func endFetchingMenu(successfully endedSuccessfully: Bool) {
        withAnimation {
            if endedSuccessfully {
                model.menuFetchState = .done
            } else {
                model.menuFetchState = .failed
            }
        }

    }
    
    func addOneItem(_ item: Order.Item) {
        
    }
    
    func removeOneItem(_ item: Order.Item) {
        
    }
    
    func addOneIngredient(_ ingredient: Menu.Ingredient, to item: Order.Item) {
        
    }
    
    func removeOneIngredient(_ ingredient: Menu.Ingredient, to item: Order.Item) {
        
    }
    
    func updatePhoneNumber(_ newValue: String?) {
        
    }
    
    func updateAddress(_ newValue: String?) {
        
    }
    
    func updateComment(_ newValue: String?) {
        
    }
    
    
//    TODO: possibly refactor buttonstate
    @Published var loginButtonState: ActionButtonState = .enabled(title: "Log In", systemImage: "")
    struct NavBar {
        var activeButton: Menu.Section = Menu.Section.allCases.first!
        var actions: Dictionary<Menu.Section, () -> Void> = [:]
    }
    
    @Published var navbar = NavBar()
    
    
}
