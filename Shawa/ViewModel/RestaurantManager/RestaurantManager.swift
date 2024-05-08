//
//  RestaurantManager.swift
//  Shawa
//
//  Created by Alex on 30.03.24.
//

import Foundation

@MainActor
protocol RestaurantManager: ObservableObject {
    var restaurants: Loadable<[Restaurant]> { get }
    var allMenuItems: [MenuItem] { get }
    func loadRestaurants()
    func findRestaurant(withMenuItem item: MenuItem) -> Restaurant?
    func menuItem(withId id: String) -> MenuItem?
    func ingredient(withId id: String) -> Ingredient?
    
    func add(restaurant: Restaurant)
    func add(_ menuItem: MenuItem, to restaurant: Restaurant)
    func add(_ ingredient: Ingredient, to restaurant: Restaurant)
    func add(_ section: MenuSection, to restaurant: Restaurant)
    func remove(restaurant: Restaurant)
    func remove(_ menuItem: MenuItem, from restaurant: Restaurant)
    func remove(_ ingredient: Ingredient, from restaurant: Restaurant)
    func remove(_ section: MenuSection, from restaurant: Restaurant)
}
