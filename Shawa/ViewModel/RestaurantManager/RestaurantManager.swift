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
}
