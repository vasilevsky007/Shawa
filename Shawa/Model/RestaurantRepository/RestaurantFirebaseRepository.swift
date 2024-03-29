//
//  RestaurantFirebaseRepository.swift
//  Shawa
//
//  Created by Alex on 28.03.24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RestaurantFirebaseRepository: RestaurantRepository {
    private var firestore = Firestore.firestore()
    private var decoder = {
        let decoder = Firestore.Decoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    private var encoder = {
        let encoder = Firestore.Encoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    
    func getRestaurants () async throws -> [Restaurant] {
        var restaurants: [Restaurant] = []
        let documents = try await firestore.collection("restaurants").getDocuments().documents
        for document in documents {
            let ingredientsDocuments = try await document.reference.collection("ingredients").getDocuments().documents
            var ingredients: [Ingredient] = []
            
            for ingredientDocument in ingredientsDocuments {
                if let ingredient = try? ingredientDocument.data(as: Ingredient.self, decoder: decoder) {
                    ingredients.append(ingredient)
                }
            }

            let sectionsDocuments = try await document.reference.collection("sections").getDocuments().documents
            var sections: [MenuSection] = []
            
            for sectionDocument in sectionsDocuments {
                if let section = try? sectionDocument.data(as: MenuSection.self, decoder: decoder) {
                    sections.append(section)
                }
            }
            
            let menuDocuments = try await document.reference.collection("menu").getDocuments().documents
            var menuItems: [MenuItem] = []
            
            for menuDocument in menuDocuments {
                let item = try menuDocument.data(as: MenuItem.self, decoder: decoder)
                    menuItems.append(item)
                
            }
            
            restaurants.append(.init(
                    id: document.data()["id"] as! String,
                    name: document.data()["name"] as! String,
                    menu: menuItems,
                    ingredients: ingredients,
                    sections: sections
                )
            )
        }
        return restaurants
    }
    
    func add(restaurant: Restaurant) async throws {
        let restaurantDocument = firestore.collection("restaurants").document(restaurant.id)
        try await restaurantDocument.setData([
            Restaurant.CodingKeys.name.stringValue : restaurant.name,
            Restaurant.CodingKeys.id.stringValue : restaurant.id,
        ])
        try await withThrowingTaskGroup(of: Void.self) { taskGroup in
            for item in restaurant.menu {
                taskGroup.addTask {
                    try await restaurantDocument
                        .collection(Restaurant.CodingKeys.menu.stringValue)
                        .document(item.id)
                        .setData(from: item, encoder: encoder)
                }
            }
            for ingredient in restaurant.ingredients {
                taskGroup.addTask {
                    try await restaurantDocument
                        .collection(Restaurant.CodingKeys.ingredients.stringValue)
                        .document(ingredient.id)
                        .setData(from: ingredient, encoder: encoder)
                }
            }
            for section in restaurant.sections {
                taskGroup.addTask {
                    try await restaurantDocument
                        .collection(Restaurant.CodingKeys.sections.stringValue)
                        .document(section.id)
                        .setData(from: section, encoder: encoder)
                }
            }
            for try await _ in taskGroup {}
        }
    }
    
    func add(_ menuItem: MenuItem, to restaurant: Restaurant) async throws {
        try await firestore
            .collection("restaurants")
            .document(restaurant.id)
            .collection(Restaurant.CodingKeys.menu.stringValue)
            .document(menuItem.id)
            .setData(from: menuItem, encoder: encoder)
    }
    
    func add(_ ingredient: Ingredient, to restaurant: Restaurant) async throws {
        try await firestore
            .collection("restaurants")
            .document(restaurant.id)
            .collection(Restaurant.CodingKeys.ingredients.stringValue)
            .document(ingredient.id)
            .setData(from: ingredient, encoder: encoder)
    }
    
    func add(_ section: MenuSection, to restaurant: Restaurant) async throws {
        try await firestore
            .collection("restaurants")
            .document(restaurant.id)
            .collection(Restaurant.CodingKeys.sections.stringValue)
            .document(section.id)
            .setData(from: section, encoder: encoder)
    }
    
    func remove(restaurant: Restaurant) async throws {
        //TODO: ensure full delete
        try await firestore
            .collection("restaurants")
            .document(restaurant.id)
            .delete()
    }
        
    func remove(_ menuItem: MenuItem, from restaurant: Restaurant) async throws {
        //TODO: ensure full delete
        try await firestore
            .collection("restaurants")
            .document(restaurant.id)
            .collection(Restaurant.CodingKeys.menu.stringValue)
            .document(menuItem.id)
            .delete()
    }
    
    func remove(_ ingredient: Ingredient, from restaurant: Restaurant) async throws {
        //TODO: ensure full delete
        try await firestore
            .collection("restaurants")
            .document(restaurant.id)
            .collection(Restaurant.CodingKeys.ingredients.stringValue)
            .document(ingredient.id)
            .delete()
    }
    
    func remove(_ section: MenuSection, from restaurant: Restaurant) async throws {
        //TODO: ensure full delete
        try await firestore
            .collection("restaurants")
            .document(restaurant.id)
            .collection(Restaurant.CodingKeys.sections.stringValue)
            .document(section.id)
            .delete()
    }
}
