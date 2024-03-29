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
    @Published private(set) var model = ShavaAppState()
    @Published private(set) var menu = Menu()
    @Published private(set) var currentOrder = Order()
    @Published private(set) var orders = UserOrders()
    
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
    
    var menuItems: Set<Menu.Item> {
        menu.items
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
    
    var userOrders: [Order] {
        orders.orders.sorted { $0.timestamp! > $1.timestamp! }
    }
    
    var orderPrice: Double {
        currentOrder.totalPrice
    }
    
    var orderUserdata: Order.UserData {
        currentOrder.user
    }
    
    var orderComment: String {
        currentOrder.comment ?? ""
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
        withAnimation {
            model.currentAuthenticationState = .authenticated
        }
    }
    
    func authenticationFailure(reason error: String) {
        withAnimation {
            model.currentAuthenticationState = .notAuthenticated
            loginButtonState = .enabled(title: error, systemImage: "exclamationmark.circle")
            Task(priority: .high) {
                try? await Task.sleep(nanoseconds: 5_000_000_000)
                self.loginButtonState = .enabled(title: self.model.currentAuthenticationFlow == .login ? "Log In" : "Register", systemImage: "")
            }
        }
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
    
    func addOneOrderItem(_ item: Order.Item) {
        var formattedItem = item
        for addition in formattedItem.additions.keys {
            if formattedItem.additions[addition] == 0 {
                formattedItem.additions.removeValue(forKey: addition)
            }
        }
        withAnimation {
            currentOrder.addOneOrderItem(formattedItem)
        }
    }
    
    func removeOneOrderItem(_ item: Order.Item) {
        withAnimation {
            currentOrder.removeOneOrderItem(item)
        }
    }
    func removeOrderItem(_ item: Order.Item) {
        withAnimation {
            currentOrder.removeOrderItem(item)
        }
    }
    
    func clearCart () {
        withAnimation {
            currentOrder.clearCart()
        }
    }
    
    func addOneIngredient(_ ingredient: Menu.Ingredient, to item: Order.Item) {
        withAnimation {
            currentOrder.addOneIngredient(ingredient, to: item)
        }
    }
    
    func removeOneIngredient(_ ingredient: Menu.Ingredient, to item: Order.Item) {
        withAnimation {
            currentOrder.removeOneIngredient(ingredient, to: item)
        }
        
    }
    
    func updatePhoneNumber(_ newValue: String) {
        currentOrder.updatePhoneNumber(newValue == "" ? nil : newValue)
    }
    
    func updateAddress(street: String, house: String, apartament: String) {
        currentOrder.updateAddress(
            street: street == "" ? nil : street,
            house: house == "" ? nil : house,
            apartament: apartament == "" ? nil : apartament)
    }
    
    func updateOrderComment(_ newValue: String?) {
        currentOrder.updateComment(newValue == "" ? nil : newValue)
    }
    
    func updateOrderUID(_ newValue: String?)  {
        currentOrder.updateUserID(newValue)
    }
    
    func addUserOrder(_ order: Order) {
        withAnimation {
            orders.addOrder(order)
        }
    }
    
    func clearUserOrders(_ order: Order) {
        withAnimation {
            orders.clearOrders()
        }
    }
    
    
//    TODO: possibly refactor buttonstate
    @Published var loginButtonState: ActionButtonState = .enabled(title: "Log In", systemImage: "")
    @Published var orderButtonState: ActionButtonState = .enabled(title: "Make an order", systemImage: "")
    
    struct NavBar {
        var activeButton: Menu.Section = Menu.Section.allCases.first!
        var actions: Dictionary<Menu.Section, () -> Void> = [:]
        
        mutating func click(on section: Menu.Section) {
            withAnimation(.easeInOut) {
                activeButton = section
                actions[section]!()
            }            
        }
    }
    
    @Published var navbar = NavBar()
    
    
}
