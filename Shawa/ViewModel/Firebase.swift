//
//  Firebase.swift
//  Shawa
//
//  Created by Alex on 8.04.23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class Firebase: ObservableObject {
    var app: ShavaAppSwiftUI
    
    var achievedInfoAboutUser: User?
    var achievedMenu = [Menu.Item]()
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    private var firestore: Firestore
    private var realtimeDatabase: DatabaseReference
    
    private func registerAuthStateHandler()  {
          if authStateHandle == nil {
              withAnimation(.easeIn) {
                  authStateHandle = Auth.auth().addStateDidChangeListener { _, user in
                      self.achievedInfoAboutUser = user
                      if (self.achievedInfoAboutUser == nil) {
                          Task { await self.app.initialAuthenticationFailure() }
                      } else {
                          Task { await self.app.authenticationSuccess(userInfo: self.achievedInfoAboutUser!) }
                      }
                  }
              }
          }
      }
    
    init(app: ShavaAppSwiftUI) {
        self.app = app
        FirebaseApp.configure()
        self.firestore = Firestore.firestore()
        //add database url in .xcconfig & info.plist to stop crash in next line
        self.realtimeDatabase = Database.database(url: "https://"+(Bundle.main.infoDictionary?["FIREBASE_REALTIME_DATABASE_URL"] as? String)!).reference()
        registerAuthStateHandler()
    }
    
    fileprivate struct FirestoreMenuItem: Codable {
        var id: Int
        var belonsToSection: DocumentReference
        var name: String
        var price: Double
        var imageURL: String
        var dateAdded: Timestamp
        var popularity: Int
        var ingredients: [DocumentReference]
        var description: String
        
        struct FirestoreSection: Codable {
            var id: Int
            var name: String
        }
        
        struct FirestoreIngredient: Codable {
            @DocumentID var ingredientDocName: String?
        }
        
        func makeMenuItem() async -> Menu.Item? {
            var belongsTo: Menu.Section?
            let belonsToDocument = try? await belonsToSection.getDocument(as: FirestoreSection.self)
            if await belonsToDocument != nil {
                belongsTo = Menu.Section(rawValue: belonsToDocument!.name)
                if belongsTo == nil {
                    return nil
                }
            } else {
                return nil
            }
            
            let ingredientsSet: Set<Menu.Ingredient> = await withTaskGroup(of: Menu.Ingredient?.self, returning: Set<Menu.Ingredient>.self) { taskGroup in
                for firestoreIngredient in ingredients {
                    taskGroup.addTask {
                        if let ingredientDocument = try? await firestoreIngredient.getDocument(as: FirestoreIngredient.self) {
                            return await Menu.Ingredient(rawValue: ingredientDocument.ingredientDocName!)
                        } else {
                            return nil
                        }
                    }
                }
                var fetchedIngredients: Set<Menu.Ingredient> = Set([])
                for await result in taskGroup {
                    if result != nil {
                        fetchedIngredients.insert(result!)
                    }
                }
                return fetchedIngredients
            }
            
            let url = URL(string: imageURL)
//            вот тут краш изза!
            var imageData: Data?
            if let tempUrl = url {
                imageData = try? Data(contentsOf: tempUrl)
            }
            let menuitem = Menu.Item(id: self.id, belogsTo: belongsTo!, name: self.name, price: self.price, image: imageData, dateAdded: self.dateAdded.dateValue(), popularity: self.popularity, ingredients: ingredientsSet, description: self.description)
            return menuitem
        }
    }
    
    //    MARK: Intents
    
    func fetchMenu() async {
            do {
                await app.startFetchingMenu()
                let documents = try await firestore.collection("menu").getDocuments().documents
                await app.clearMenu()
                for document in documents {
                    let decoder = Firestore.Decoder()
                    decoder.dateDecodingStrategy = .iso8601
                    do {
                        let decodedMenuItem = try await document.data(as: FirestoreMenuItem.self, decoder: decoder).makeMenuItem()
                        await app.addMenuItem(decodedMenuItem)
                    } catch {
                        print("map error: \(error)")
                    }
                }
                await app.endFetchingMenu(successfully: true)
            } catch {
                print("fetchmenu error: " + error.localizedDescription)
                await app.endFetchingMenu(successfully: false)
            }
            
        }
    
    func login(email: String, password: String) async {
        print("auth start")
        DispatchQueue.main.async {
            self.app.startLogin()
        }
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            achievedInfoAboutUser = result.user
            print("User" + (achievedInfoAboutUser?.uid ?? "") + "signed in")
            DispatchQueue.main.async {
                withAnimation(.easeIn) {
                    self.app.authenticationSuccess(userInfo: self.achievedInfoAboutUser!)
                }
                
            }
        } catch {
            print(error)
            DispatchQueue.main.async {
                self.app.authenticationFailure(reason: error.localizedDescription)
            }
        }
    }

    func register(email: String, password: String) async {
        print("register start")
        DispatchQueue.main.async {
            self.app.startRegistration()
        }
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            achievedInfoAboutUser = result.user
            print("User" + (achievedInfoAboutUser?.uid ?? "") + "registred")
            DispatchQueue.main.async {
                self.app.authenticationSuccess(userInfo: self.achievedInfoAboutUser!)
            }
        } catch {
            print(error)
            DispatchQueue.main.async {
                self.app.authenticationFailure(reason: error.localizedDescription)
            }
        }
    }
    
    func sendOrder() async throws {
        var orderItemsRestructurised: Array<[String: Any]> = []
        var additionsRestructurised: [[String: Any]] = []
        
        var autoParsed = try await (JSONSerialization.jsonObject(with: JSONEncoder().encode(app.currentOrder)) as? [String: Any] ?? [:])
        var orderItems: Array? = autoParsed["orderItems"] as? Array<Any>
        if orderItems  != nil {
            orderItemsRestructurised.removeAll()
            for i in 0..<(orderItems!.count / 2) {
                var formattedItem = orderItems![i * 2] as! [String:Any]
                formattedItem["id"] = nil
                
                var formattedMenuItem = formattedItem["item"] as! [String:Any]
                formattedMenuItem["id"] = nil
                formattedMenuItem["dateAdded"] = nil
                formattedMenuItem["popularity"] = nil
                formattedMenuItem["image"] = nil
                formattedMenuItem["description"] = nil
                formattedMenuItem["ingredients"] = nil
                formattedItem["item"] = formattedMenuItem
                
                var additions: Array? = formattedItem["additions"] as? Array<Any>
                if additions != nil {
                    additionsRestructurised.removeAll()
                    for j in 0..<(additions!.count / 2) {
                        additionsRestructurised.append(
                            ["addition":additions![j * 2], "count":additions![j * 2 + 1]]
                        )
                    }
                    formattedItem["additions"] = additionsRestructurised
                }
                
                orderItemsRestructurised.append(
                    ["orderItem":formattedItem, "count":orderItems![i * 2 + 1]]
                )
            }
            autoParsed["orderItems"] = orderItemsRestructurised
        }
        try await realtimeDatabase.child("ordersAPL").child(app.currentOrder.user.userID!).child(Date.now.debugDescription).setValue(autoParsed)
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            //TODO: indicate failure in ui
            print("error: " + error.localizedDescription)
        }
    }
    
    func deleteAccount() async {
        do {
            try await achievedInfoAboutUser?.delete()
        } catch{
            //TODO: indicate failure in ui
            print("error: " + error.localizedDescription)
        }
    }
    
}
