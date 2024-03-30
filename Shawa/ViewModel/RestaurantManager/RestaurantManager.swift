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
    func loadRestaurants()
}
