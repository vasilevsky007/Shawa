//
//  IngredientEditorView.swift
//  ShawaAdmin
//
//  Created by Alex on 13.05.24.
//

import SwiftUI

struct IngredientEditorView<RestaurantManagerType: RestaurantManager>: View {
    @EnvironmentObject private var restaurantManager: RestaurantManagerType
    
    @Environment(\.dismiss) private var dismiss
    
    enum FocusableFields: Hashable {
        case name, cost
    }
    
    @FocusState var focusedField: FocusableFields?
    
    @State private var enteredName: String
    @State private var enteredCost: String
    
    private var isNew: Bool
    private var ingredient: Ingredient
    private var restaurant: Restaurant
    
    private var isEnteredInfoValidated: Bool {
        return !enteredName.isEmpty &&
        Double(enteredCost) != nil &&
        Double(enteredCost) ?? -1 > 0
    }
    
    
    init(ingredient: Ingredient, restaurant: Restaurant, isNew: Bool = false) {
        self.enteredName = ingredient.name
        self.enteredCost = ingredient.cost == 0 ?
        "" :
        ingredient.cost
            .formatted()
            .replacingOccurrences(of: ",", with: ".")
        self.ingredient = ingredient
        self.restaurant = restaurant
        self.isNew = isNew
    }
    
    var body: some View {
        VStack {
            HStack(alignment:.top) {
                Text(isNew ? "Adding new ingredient" : "Editing \(ingredient.name)")
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.defaultBrown)
                    .font(.montserratBold(size: 24))
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 40))
                        .foregroundColor(.lighterBrown)
                }
            }
            
            Spacer(minLength: 0)
            
            PrettyTextField(
                text: $enteredName,
                label: "Ingredient name",
                color: .defaultBrown,
                isSystemImage: true,
                image: "rectangle.and.paperclip",
                focusState: $focusedField,
                focusedValue: .name,
                keyboardType: .default,
                submitLabel: .next) {
                    focusedField = .cost
                }
            
            PrettyTextField(
                text: $enteredCost,
                label: "Ingredient price",
                color: .defaultBrown,
                isSystemImage: true,
                image: "tag",
                focusState: $focusedField,
                focusedValue: .cost,
                keyboardType: .decimalPad,
                submitLabel: .done) {
                    focusedField = nil
                }
            .padding(.bottom, .Constants.standardSpacing)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
            .onChange(of: enteredCost) { _ in
                enteredCost = enteredCost.replacingOccurrences(of: ",", with: ".")
            }
            
            HStack(spacing: 0) {
                Spacer(minLength: 0)
                Text("ID: \(ingredient.id)")
                    .font(.main(size: 10))
                    .foregroundStyle(.lighterBrown)
            }
            
            HStack {
                PrettyButton(text: isNew ? "Add ingredient" : "Save changes",
                             color: .primaryBrown,
                             unactiveColor: .lightBrown,
                             isActive: isEnteredInfoValidated,
                             infiniteWidth: true) {
                    var edited = ingredient
                    edited.name = enteredName
                    edited.cost = Double(enteredCost)!
                    restaurantManager.add(edited, to: restaurant)
                    dismiss()
                }
                .frame(minWidth: .Constants.EditorViews.addButtonMinWidth)
                
                PrettyButton(text: "Cancel",
                             color: .red,
                             unactiveColor: .lightBrown,
                             isActive: true,
                             infiniteWidth: true) {
                    dismiss()
                }
            }
            .frame(height: .Constants.lineElementHeight)
        }
        .padding(.all, .Constants.horizontalSafeArea)
    }
}


#Preview {
    @State var rm = RestaurantManagerStub()
    
    return Color.red
        .sheet(isPresented: .constant(true)) {
            
            if #available(iOS 16.0, *) {
                IngredientEditorView<RestaurantManagerStub>(
                    ingredient: Ingredient(name: "", cost: 123.321),
                    restaurant: rm.restaurants.value!.first!
                )
                    .environmentObject(rm)
                    .presentationDetents(.init([.small]))
            } else {
                // Fallback on earlier versions
            }
        }
}
