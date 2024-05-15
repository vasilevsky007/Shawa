//
//  FirestoreRestaurantManager.swift
//  Shawa
//
//  Created by Alex on 30.03.24.
//

import SwiftUI

@MainActor
final class FirestoreRestaurantManager: RestaurantManager {
    private var repository = FirestoreRestaurantRepository()
    private var loadTask: Task<(), Never>? = nil
    
    @Published private(set) var restaurants: Loadable<[Restaurant]> = .notLoaded(error: nil)
    
    var allMenuItems: [MenuItem] {
        guard let restaurants = restaurants.value else { return [] }
        var result = [MenuItem]()
        for restaurant in restaurants {
            result.append(contentsOf: restaurant.menu)
        }
        return result
    }
}


//MARK: - Convinience funcs

private extension FirestoreRestaurantManager {
    func updateRestaurants(to newRestaurants: Loadable<[Restaurant]>) {
        withAnimation {
            restaurants = newRestaurants
        }
    }
    
    func makeChangeUpdatingRestaurants(_ makeChange: @escaping () async throws -> Void) {
        Task {
            let task = Task.detached {
                try await makeChange()
            }
            do {
                try await task.value
                loadRestaurants()
            } catch {
                loadRestaurants()
            }
        }
    }
}


//MARK: - General intents

extension FirestoreRestaurantManager {
    func loadRestaurants() {
        updateRestaurants(to: .loading(last: restaurants.value))
        loadTask?.cancel()
        loadTask = Task.detached {
            do {
                let loadedRestaurants = try await self.repository.getRestaurants()
                Task {
                    await self.updateRestaurants(to: .loaded(loadedRestaurants))
                }
            } catch is CancellationError {
                print("task cancelled")
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
            if let item = restaurant.menu.first(where: { $0.id == id }) {
                return item
            }
        }
        return nil
    }
    
    func ingredient(withId id: String) -> Ingredient? {
        guard let restaurants = restaurants.value else { return nil }
        for restaurant in restaurants {
            if let ingredient = restaurant.ingredients.first(where: { $0.id == id }) {
                return ingredient
            }
        }
        return nil
    }
}


//MARK: - Edit Intents

extension FirestoreRestaurantManager {
    func add(restaurant: Restaurant) {
        makeChangeUpdatingRestaurants {
            try await self.repository.add(restaurant: restaurant)
        }
    }
    
    func add(_ menuItem: MenuItem, to restaurant: Restaurant) {
        makeChangeUpdatingRestaurants {
            try await self.repository.add(menuItem, to: restaurant)
        }
    }
    
    func add(_ ingredient: Ingredient, to restaurant: Restaurant) {
        makeChangeUpdatingRestaurants {
            try await self.repository.add(ingredient, to: restaurant)
        }
    }
    
    func add(_ section: MenuSection, to restaurant: Restaurant) {
        makeChangeUpdatingRestaurants {
            try await self.repository.add(section, to: restaurant)
        }
    }
    
    func remove(restaurant: Restaurant) {
        makeChangeUpdatingRestaurants {
            try await self.repository.remove(restaurant: restaurant)
        }
    }
    
    func remove(_ menuItem: MenuItem, from restaurant: Restaurant) {
        makeChangeUpdatingRestaurants {
            try await self.repository.remove(menuItem, from: restaurant)
        }
    }
    
    func remove(_ ingredient: Ingredient, from restaurant: Restaurant) {
        makeChangeUpdatingRestaurants {
            try await self.repository.remove(ingredient, from: restaurant)
        }
    }
    
    func remove(_ section: MenuSection, from restaurant: Restaurant) {
        makeChangeUpdatingRestaurants {
            try await self.repository.remove(section, from: restaurant)
        }
    }
}
