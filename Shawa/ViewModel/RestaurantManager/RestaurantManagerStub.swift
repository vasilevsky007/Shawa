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
            ingredients: [.init(name: "ingr1", cost: 0.30),.init(name: "ingr2", cost: 3.001),],
            sections: [.init(name: "sect1"), .init(name: "sect2")]
        ),
        .init(
            name: "rest2",
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
            ingredients: [.init(name: "ingr1", cost: 0.3)],
            sections: [.init(name: "sect1"), .init(name: "sect2")]
        ),
        
    ])
    
    func loadRestaurants() {
        withAnimation {
            restaurants = .loading(last: restaurants.value)
        }
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            withAnimation {
                restaurants = .loaded(restaurants.value!)
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
    
    
    // MARK: -restaurant management
    
    func add(restaurant: Restaurant) {
        var values = restaurants.value ?? []
        values.append(restaurant)
        restaurants = .loaded(values)
    }
    func add(_ menuItem: MenuItem, to restaurant: Restaurant) {
        var values = restaurants.value ?? []
        if let i = values.firstIndex(where: { $0.id == restaurant.id }) {
            values[i].menu.append(menuItem)
        }
        restaurants = .loaded(values)
    }
    func add(_ ingredient: Ingredient, to restaurant: Restaurant)  {
        var values = restaurants.value ?? []
        if let i = values.firstIndex(where: { $0.id == restaurant.id }) {
            values[i].ingredients.append(ingredient)
        }
        restaurants = .loaded(values)
    }
    func add(_ section: MenuSection, to restaurant: Restaurant) {
        var values = restaurants.value ?? []
        if let i = values.firstIndex(where: { $0.id == restaurant.id }) {
            values[i].sections.append(section)
        }
        restaurants = .loaded(values)
    }
    func remove(restaurant: Restaurant) {
        var values = restaurants.value ?? []
        values.removeAll(where: { $0.id == restaurant.id })
        restaurants = .loaded(values)
    }
    func remove(_ menuItem: MenuItem, from restaurant: Restaurant) {
        var values = restaurants.value ?? []
        if let i = values.firstIndex(where: { $0.id == restaurant.id }) {
            values[i].menu.removeAll(where: { $0.id == menuItem.id })
        }
        restaurants = .loaded(values)
    }
    func remove(_ ingredient: Ingredient, from restaurant: Restaurant) {
        var values = restaurants.value ?? []
        if let i = values.firstIndex(where: { $0.id == restaurant.id }) {
            values[i].ingredients.removeAll(where: { $0.id == ingredient.id })
        }
        restaurants = .loaded(values)
    }
    func remove(_ section: MenuSection, from restaurant: Restaurant) {
        var values = restaurants.value ?? []
        if let i = values.firstIndex(where: { $0.id == restaurant.id }) {
            values[i].sections.removeAll(where: { $0.id == section.id })
        }
        restaurants = .loaded(values)
    }
}
