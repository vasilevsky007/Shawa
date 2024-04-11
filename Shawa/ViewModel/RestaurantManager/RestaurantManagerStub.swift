//
//  RestaurantManagerStub.swift
//  Shawa
//
//  Created by Alex on 31.03.24.
//

import SwiftUI

@MainActor
class RestaurantManagerStub: RestaurantManager {
    var allMenuItems: [MenuItem] {
        restaurants.value!.first!.menu
    }
    
    var restaurants: Loadable<[Restaurant]> = .loaded([
        .init(
            id: "1",
            name: "rest1",
            menu: [
                .init(id: "1", sectionIDs: .init(arrayLiteral: "1"), name: "Agdsuhbjlk;lm geyaduhjlskm ufeyhodijakmo gufehdijkm yguefhoidjskm hefij", price: 3.99, image: .init(string: "https://upload.wikimedia.org/wikipedia/ru/d/d8/Tianasquare.jpg"), dateAdded: Date.now, popularity: 12, ingredientIDs: .init(arrayLiteral: "1"), description: "sad qwd"),
                .init(id: "2", sectionIDs: .init(arrayLiteral: "1"), name: "цйу", price: 5.99, image: .init(string: "https://upload.wikimedia.org/wikipedia/ru/d/d8/Tianasquare.jpg"), dateAdded: Date.now, popularity: 12, ingredientIDs: .init(arrayLiteral: "1"), description: "sad qwd"),
                .init(id: "3", sectionIDs: .init(arrayLiteral: "1"), name: "цйу", price: 3.99, image: .init(string: "https://upload.wikimedia.org/wikipedia/ru/d/d8/Tianasquare.jpg"), dateAdded: Date.now, popularity: 12, ingredientIDs: .init(arrayLiteral: "1"), description: "sad qwd"),
                .init(id: "4", sectionIDs: .init(arrayLiteral: "1"), name: "цйу", price: 3.99, image: .init(string: "https://upload.wikimedia.org/wikipedia/ru/d/d8/Tianasquare.jpg"), dateAdded: Date.now, popularity: 12, ingredientIDs: .init(arrayLiteral: "1"), description: "sad qwd"),
                .init(id: "5", sectionIDs: .init(arrayLiteral: "1"), name: "цйу", price: 3.99, image: .init(string: "https://upload.wikimedia.org/wikipedia/ru/d/d8/Tianasquare.jpg"), dateAdded: Date.now, popularity: 12, ingredientIDs: .init(arrayLiteral: "1"), description: "sad qwd"),
                .init(id: "6", sectionIDs: .init(arrayLiteral: "1"), name: "цйу", price: 3.99, image: .init(string: "https://upload.wikimedia.org/wikipedia/ru/d/d8/Tianasquare.jpg"), dateAdded: Date.now, popularity: 12, ingredientIDs: .init(arrayLiteral: "1"), description: "sad qwd"),
                .init(id: "7", sectionIDs: .init(arrayLiteral: "1"), name: "цйу", price: 3.99, image: .init(string: "https://upload.wikimedia.org/wikipedia/ru/d/d8/Tianasquare.jpg"), dateAdded: Date.now, popularity: 12, ingredientIDs: .init(arrayLiteral: "1"), description: "sad qwd"),
                .init(id: "8", sectionIDs: .init(arrayLiteral: "2"), name: "цйу", price: 3.99, image: .init(string: "https://upload.wikimedia.org/wikipedia/ru/d/d8/Tianasquare.jpg"), dateAdded: Date.now, popularity: 12, ingredientIDs: .init(arrayLiteral: "1"), description: "sad qwd"),
                .init(id: "9", sectionIDs: .init(arrayLiteral: "2"), name: "цйу", price: 3.99, image: .init(string: "https://upload.wikimedia.org/wikipedia/ru/d/d8/Tianasquare.jpg"), dateAdded: Date.now, popularity: 12, ingredientIDs: .init(arrayLiteral: "1"), description: "sad qwd"),
                .init(id: "10", sectionIDs: .init(arrayLiteral: "2"), name: "цйу", price: 3.99, image: .init(string: "https://upload.wikimedia.org/wikipedia/ru/d/d8/Tianasquare.jpg"), dateAdded: Date.now, popularity: 12, ingredientIDs: .init(arrayLiteral: "1"), description: "sad qwd"),
                .init(id: "11", sectionIDs: .init(arrayLiteral: "2"), name: "цйу", price: 3.99, image: .init(string: "https://upload.wikimedia.org/wikipedia/ru/d/d8/Tianasquare.jpg"), dateAdded: Date.now, popularity: 12, ingredientIDs: .init(arrayLiteral: "1"), description: "sad qwd"),
                .init(id: "12", sectionIDs: .init(arrayLiteral: "2"), name: "цйу", price: 3.99, image: .init(string: "https://upload.wikimedia.org/wikipedia/ru/d/d8/Tianasquare.jpg"), dateAdded: Date.now, popularity: 12, ingredientIDs: .init(arrayLiteral: "1"), description: "sad qwd"),
                .init(id: "13", sectionIDs: .init(arrayLiteral: "1"), name: "цйу", price: 3.99, image: .init(string: "https://upload.wikimedia.org/wikipedia/ru/d/d8/Tianasquare.jpg"), dateAdded: Date.now, popularity: 12, ingredientIDs: .init(arrayLiteral: "1"), description: "sad qwd"),
            ],
            ingredients: [.init(id: "1", name: "ingr1", cost: 0.3)],
            sections: [.init(id: "1", name: "sect1"), .init(id: "2", name: "sect2")]
        )
    ])
    
    func loadRestaurants() {
        withAnimation {
            print(123)
            restaurants = .loading(last: restaurants.value)
        }
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            withAnimation {
                restaurants = .loaded(restaurants.value!)
                print(456)
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
