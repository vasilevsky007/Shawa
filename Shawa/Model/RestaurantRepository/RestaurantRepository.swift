//
//  RestaurantRepository.swift
//  Shawa
//
//  Created by Alex on 28.03.24.
//

import Foundation

protocol RestaurantRepository {
    func getRestaurants () async throws -> [Restaurant]
    func add(restaurant: Restaurant) async throws
    func add(_ menuItem: MenuItem, to restaurant: Restaurant) async throws
    func add(_ ingredient: Ingredient, to restaurant: Restaurant) async throws
    func add(_ section: MenuSection, to restaurant: Restaurant) async throws
    func remove(restaurant: Restaurant) async throws
    func remove(_ menuItem: MenuItem, from restaurant: Restaurant) async throws
    func remove(_ ingredient: Ingredient, from restaurant: Restaurant) async throws
    func remove(_ section: MenuSection, from restaurant: Restaurant) async throws
}
