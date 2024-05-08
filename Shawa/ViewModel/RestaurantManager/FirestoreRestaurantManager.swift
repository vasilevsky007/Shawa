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
    
    func add(restaurant: Restaurant) {
        Task.detached {
            do {
                try await self.repository.add(restaurant: restaurant)
            } catch {
                Task {
                    await self.loadRestaurants()
                }
            }
        }
    }
    
    func add(_ menuItem: MenuItem, to restaurant: Restaurant) {
        Task.detached {
            do {
                try await self.repository.add(menuItem, to: restaurant)
            } catch {
                Task {
                    await self.loadRestaurants()
                }
            }
        }
    }
    
    func add(_ ingredient: Ingredient, to restaurant: Restaurant) {
        Task.detached {
            do {
                try await self.repository.add(ingredient, to: restaurant)
            } catch {
                Task {
                    await self.loadRestaurants()
                }
            }
        }
    }
    
    func add(_ section: MenuSection, to restaurant: Restaurant) {
        Task.detached {
            do {
                try await self.repository.add(section, to: restaurant)
            } catch {
                Task {
                    await self.loadRestaurants()
                }
            }
        }
    }
    
    func remove(restaurant: Restaurant) {
        Task.detached {
            do {
                try await self.repository.remove(restaurant: restaurant)
            } catch {
                Task {
                    await self.loadRestaurants()
                }
            }
        }
    }
    
    func remove(_ menuItem: MenuItem, from restaurant: Restaurant) {
        Task.detached {
            do {
                try await self.repository.remove(menuItem, from: restaurant)
            } catch {
                Task {
                    await self.loadRestaurants()
                }
            }
        }
    }
    
    func remove(_ ingredient: Ingredient, from restaurant: Restaurant) {
        Task.detached {
            do {
                try await self.repository.remove(ingredient, from: restaurant)
            } catch {
                Task {
                    await self.loadRestaurants()
                }
            }
        }
    }
    
    func remove(_ section: MenuSection, from restaurant: Restaurant) {
        Task.detached {
            do {
                try await self.repository.remove(section, from: restaurant)
            } catch {
                Task {
                    await self.loadRestaurants()
                }
            }
        }
    }
}
