//
//  FirestoreRestaurantManager.swift
//  Shawa
//
//  Created by Alex on 30.03.24.
//

import SwiftUI

@MainActor
class FirestoreRestaurantManager: RestaurantManager {
    
    private var repository = FirestoreRestaurantRepository()
    
    @Published private(set) var restaurants: Loadable<[Restaurant]> = .notLoaded(error: nil)
    
    var allMenuItems: [MenuItem] {
        guard let restaurants = restaurants.value else { return [] }
        var result = [MenuItem]()
        for restaurant in restaurants {
            result.append(contentsOf: restaurant.menu)
        }
        return result
    }
    
    private func updateRestaurants(to newRestaurants: Loadable<[Restaurant]>) {
        withAnimation {
            restaurants = newRestaurants
        }
    }
    
    func loadRestaurants() {
        updateRestaurants(to: .loading(last: restaurants.value))
        Task.detached {
            do {
                let loadedRestaurants = try await self.repository.getRestaurants()
                Task {
                    await self.updateRestaurants(to: .loaded(loadedRestaurants))
                }
            } catch {
                Task {
                    await self.updateRestaurants(to: .notLoaded(error: error))
                }
            }
        }
    }
    
    func findRestaurant(withMenuItem item: MenuItem) -> Restaurant? {
        restaurants.value?.first(where: {
            $0.menu.contains(where: {
                $0.id == item.id
            })
        })
    }
    
    func menuItem(withId id: String) -> MenuItem? {
        guard let restaurants = restaurants.value else { return nil }
        for restaurant in restaurants {
            return restaurant.menu.first(where: { $0.id == id })
        }
        return nil
    }
    
    func ingredient(withId id: String) -> Ingredient? {
        guard let restaurants = restaurants.value else { return nil }
        for restaurant in restaurants {
            return restaurant.ingredients.first(where: { $0.id == id })
        }
        return nil
    }
}
