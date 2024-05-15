//
//  FirestoreRestaurantRepository.swift
//  Shawa
//
//  Created by Alex on 28.03.24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestoreRestaurantRepository: RestaurantRepository {
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
        try Task.checkCancellation()
        let documents = try await firestore.collection("restaurants").getDocuments().documents
        try Task.checkCancellation()
        for document in documents {
            try Task.checkCancellation()
            let ingredientsDocuments = try await document.reference.collection("ingredients").getDocuments().documents
            try Task.checkCancellation()
            var ingredients: [Ingredient] = []
            
            for ingredientDocument in ingredientsDocuments {
                try Task.checkCancellation()
                if let ingredient = try? ingredientDocument.data(as: Ingredient.self, decoder: decoder) {
                    ingredients.append(ingredient)
                }
            }
            
            try Task.checkCancellation()
            let sectionsDocuments = try await document.reference.collection("sections").getDocuments().documents
            try Task.checkCancellation()
            var sections: [MenuSection] = []
            
            for sectionDocument in sectionsDocuments {
                try Task.checkCancellation()
                if let section = try? sectionDocument.data(as: MenuSection.self, decoder: decoder) {
                    sections.append(section)
                }
            }
            try Task.checkCancellation()
            let menuDocuments = try await document.reference.collection("menu").getDocuments().documents
            try Task.checkCancellation()
            var menuItems: [MenuItem] = []
            
            for menuDocument in menuDocuments {
                try Task.checkCancellation()
                if let item = try? menuDocument.data(as: MenuItem.self, decoder: decoder) {
                    menuItems.append(item)
                }
            }
            
            guard let id = document.data()["id"] as? String else { continue }
            guard let name = document.data()["name"] as? String else { continue }
            
            restaurants.append(.init(
                    id: id,
                    name: name,
                    menu: menuItems.sorted(by: {$0.name < $1.name}),
                    ingredients: ingredients.sorted(by: {$0.name < $1.name}),
                    sections: sections.sorted(by: {$0.name < $1.name})
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
