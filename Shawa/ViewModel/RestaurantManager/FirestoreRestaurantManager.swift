//
//  FirestoreRestaurantManager.swift
//  Shawa
//
//  Created by Alex on 30.03.24.
//

import Foundation

@MainActor
class FirestoreRestaurantManager: RestaurantManager {
    
    private var repository = FirestoreRestaurantRepository()
    
    @Published private(set) var restaurants: Loadable<[Restaurant]> = .notLoaded(error: nil)
    
    private func updateRestaurants(to newRestaurants: Loadable<[Restaurant]>) {
        restaurants = newRestaurants
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
}
