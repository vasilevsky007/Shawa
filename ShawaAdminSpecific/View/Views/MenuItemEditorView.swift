//
//  MenuItemEditorView.swift
//  ShawaAdmin
//
//  Created by Alex on 14.05.24.
//

import SwiftUI

struct MenuItemEditorView<RestaurantManagerType: RestaurantManager>: View {
    @EnvironmentObject private var restaurantManager: RestaurantManagerType
    
    @Environment(\.dismiss) private var dismiss
    
    enum FocusableFields: Hashable {
        case name, imageURL, cost, description
    }
    
    @FocusState var focusedField: FocusableFields?
    
    @State private var enteredName: String
    @State private var enteredImageURL: String
    @State private var enteredPrice: String
    @State private var enteredDescription: String
    @State private var selectedSectionID: String
    @State private var selectedIngredientID: String
    
    @State private var menuItem: MenuItem
    
    private var isNew: Bool
    private var restaurant: Restaurant

    init(menuItem: MenuItem, restaurant: Restaurant, isNew: Bool = false) {
        self.enteredName = menuItem.name
        self.enteredDescription = menuItem.description
        self.enteredImageURL = menuItem.image?.absoluteString ?? ""
        self.enteredPrice = menuItem.price == 0 ?
        "" :
        menuItem.price
            .formatted()
            .replacingOccurrences(of: ",", with: ".")
        self.selectedSectionID = restaurant.sections.first?.id ?? ""
        self.selectedIngredientID = restaurant.ingredients.first?.id ?? ""
        self.menuItem = menuItem
        self.restaurant = restaurant
        self.isNew = isNew
    }
    
    var body: some View {
        VStack {
            HStack(alignment:.top) {
                Text(isNew ? "Adding new menu item" : "Editing \(menuItem.name)")
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

            if #available(iOS 16.0, *) {
                if #available(iOS 16.4, *) {
                    ScrollView(.vertical, showsIndicators: false) {
                        contentBody
                    }
                    .scrollDismissesKeyboard(.immediately)
                    .scrollBounceBehavior(.basedOnSize)
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        contentBody
                    }
                    .scrollDismissesKeyboard(.immediately)
                }
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    contentBody
                }
            }
            
            HStack(spacing: 0) {
                Spacer(minLength: 0)
                Text("ID: \(menuItem.id)")
                    .font(.main(size: 10))
                    .foregroundStyle(.lighterBrown)
            }
            
            HStack {
                PrettyButton(text: isNew ? "Add menu item" : "Save changes",
                             color: .primaryBrown,
                             unactiveColor: .lightBrown,
                             isActive: isEnteredInfoValidated,
                             infiniteWidth: true) {
                    save()
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
            .padding(.bottom, .Constants.standardSpacing)
        }
        .padding(.all.subtracting(.bottom), .Constants.horizontalSafeArea)
    }
}


// MARK: - Validation

private extension MenuItemEditorView {
    var isEnteredInfoValidated: Bool {
        return !enteredName.isEmpty &&
        (URL(string: enteredImageURL) != nil || enteredImageURL == "") &&
        Double(enteredPrice) != nil &&
        Double(enteredPrice) ?? -1 > 0 &&
        isIngredientsValidated &&
        isSectionsValidated
    }
    
    var isIngredientsValidated: Bool {
        var result = true
        for ingredientID in menuItem.ingredientIDs {
            if restaurant.ingredients.first(where: { $0.id == ingredientID }) == nil {
                result = false
                break
            }
        }
        return result
    }

    var isSectionsValidated: Bool {
        var result = true
        for sectionID in menuItem.sectionIDs {
            if restaurant.sections.first(where: { $0.id == sectionID }) == nil {
                result = false
                break
            }
        }
        return result && !menuItem.sectionIDs.isEmpty
    }
}

// MARK: - Intents

private extension MenuItemEditorView {
    func save() {
        var edited = menuItem
        edited.name = enteredName
        edited.price = Double(enteredPrice)!
        edited.image = enteredImageURL.isEmpty ? nil : URL(string: enteredImageURL)
        edited.description = enteredDescription
        restaurantManager.add(edited, to: restaurant)
        dismiss()
    }
}


// MARK: - Components

private extension MenuItemEditorView {
    @ViewBuilder
    var contentBody: some View {
        Spacer(minLength: 0)
        
        nameField

        imageField
        
        priceField
        .toolbar { //FIXME: not working
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusedField = nil
                }
            }
        }
        .onChange(of: enteredPrice) { _ in
            enteredPrice = enteredPrice.replacingOccurrences(of: ",", with: ".")
        }
        
        sectionAdder
        
        ingredientAdder
        
        descriptionField
    }
    
    var nameField: some View {
        PrettyTextField(
            text: $enteredName,
            label: "Menu item name",
            color: .defaultBrown,
            isSystemImage: true,
            image: "note.text",
            focusState: $focusedField,
            focusedValue: .name,
            keyboardType: .default,
            submitLabel: .next) {
                focusedField = .imageURL
            }
    }
    
    var imageField: some View {
        PrettyTextField(
            text: $enteredImageURL,
            label: "Menu item image URL",
            color: .defaultBrown,
            isSystemImage: true,
            image: "photo",
            focusState: $focusedField,
            focusedValue: .imageURL,
            keyboardType: .webSearch,
            submitLabel: .next) {
                focusedField = .cost
            }
    }
    
    var priceField: some View {
        PrettyTextField(
            text: $enteredPrice,
            label: "Menu item price",
            color: .defaultBrown,
            isSystemImage: true,
            image: "tag",
            focusState: $focusedField,
            focusedValue: .cost,
            keyboardType: .decimalPad,
            submitLabel: .done) {
                focusedField = nil
            }
    }
    
    var sectionAdder: some View {
        VStack(alignment: .leading, spacing: .Constants.standardSpacing) {
            Text("Adding sections")
                .multilineTextAlignment(.leading)
                .foregroundStyle(.defaultBrown)
                .padding(.all.subtracting(.bottom), .Constants.standardSpacing)
                .font(.montserratBold(size: 16))
            
            FlowLayout(items: .init(menuItem.sectionIDs)) { sectionID in
                TagBox(
                    text: LocalizedStringKey(restaurant.sections.first(where: { $0.id == sectionID })?.name ??
                                             "Section with such id cannot be found"),
                    isDeletable: true) {
                        menuItem.sectionIDs.remove(sectionID)
                    }
            }
            .padding(.horizontal, .Constants.standardSpacing)
            
            HStack(spacing: .Constants.standardSpacing) {
                HStack(spacing: 0) {
                    Text("Choose section to add")
                        .padding(.leading, .Constants.standardSpacing)
                        .font(.main(size: 14))
                        .foregroundStyle(.defaultBrown)
                    
                    Spacer(minLength: 0)
                    
                    Picker(selection: $selectedSectionID) {
                        ForEach(restaurant.sections) { section in
                            HStack(spacing:0) {
                                Text(section.name)
                                    .font(.main(size: 14))
                                    .foregroundStyle(.defaultBrown)
                            }
                            .tag(section.id)
                        }
                    } label: {
                        
                    }.pickerStyle(.menu)
                        .tint(.primaryBrown)
                }
                PrettyButton(text: "Add", color: .primaryBrown, isActive: true) {
                    if !selectedSectionID.isEmpty {
                        menuItem.sectionIDs.insert(selectedSectionID)
                    }
                }
                .frame(height: .Constants.lineElementHeight)
                .padding([.trailing, .bottom], .Constants.borderWidth)
                .layoutPriority(50)
            }
        }
            .borderedElement()
    }
    
    var ingredientAdder: some View {
        VStack(alignment: .leading, spacing: .Constants.standardSpacing) {
            Text("Adding ingredients")
                .multilineTextAlignment(.leading)
                .foregroundStyle(.defaultBrown)
                .padding(.all.subtracting(.bottom), .Constants.standardSpacing)
                .font(.montserratBold(size: 16))
            
            FlowLayout(items: .init(menuItem.ingredientIDs)) { ingredientID in
                TagBox(
                    text: LocalizedStringKey(restaurant.ingredients.first(where: { $0.id == ingredientID })?.name ??
                                              "Ingredient with such id cannot be found"),
                    isDeletable: true) {
                        menuItem.ingredientIDs.remove(ingredientID)
                    }
            }
            .padding(.horizontal, .Constants.standardSpacing)
            
            HStack(spacing: .Constants.standardSpacing) {
                HStack(spacing: 0) {
                    Text("Choose ingredient to add")
                        .lineLimit(3)
                        .padding(.leading, .Constants.standardSpacing)
                        .font(.main(size: 14))
                        .foregroundStyle(.defaultBrown)
                    Spacer(minLength: 0)
                    
                    Picker(selection: $selectedIngredientID) {
                        ForEach(restaurant.ingredients) { ingredient in
                            HStack(spacing:0) {
                                Text(ingredient.name)
                                    .font(.main(size: 14))
                                    .foregroundStyle(.defaultBrown)
                            }
                            .tag(ingredient.id)
                        }
                    } label: {
                        
                    }
                        .pickerStyle(.menu)
                        .tint(.primaryBrown)
                }
                PrettyButton(text: "Add", color: .primaryBrown, isActive: true) {
                    if !selectedIngredientID.isEmpty {
                        menuItem.ingredientIDs.insert(selectedIngredientID)
                    }
                }
                .frame(height: .Constants.lineElementHeight)
                .padding([.trailing, .bottom], .Constants.borderWidth)
                .layoutPriority(50)
            }
        }
            .borderedElement()
    }
    
    var descriptionField: some View {
        VStack(alignment: .leading, spacing: .Constants.halfSpacing) {
            HStack(spacing: .Constants.halfSpacing) {
                Image(systemName: "doc.plaintext")
                    .font(.main(size: 16))
                Text("Menu item description")
                    .font(.montserratBold(size: 16))
            }
                .padding(.horizontal, .Constants.halfSpacing)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.defaultBrown)
            
            TextEditor(text: $enteredDescription)
                .toolbar { //`FIXME: not working
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            focusedField = nil
                        }
                    }
                }
                .focused($focusedField, equals: .description)
                .font(.main(size: 14))
                .foregroundStyle(.defaultBrown)
                .frame(minHeight: .Constants.lineElementHeight, maxHeight: .Constants.lineElementHeight * 4)

                
        }
        .padding(.Constants.halfSpacing)
        .borderedElement()
    }
}

#Preview {
    @State var rm = RestaurantManagerStub()
    
    return Color.red
        .sheet(isPresented: .constant(true)) {
            
            if #available(iOS 16.0, *) {
                MenuItemEditorView<RestaurantManagerStub>(
                    menuItem: rm.restaurants.value!.first!.menu.first!, //.init(sectionIDs: .init(), name: "", price: 0, ingredientIDs: .init(), description: ""),
                    restaurant: rm.restaurants.value!.first!,
                    isNew: true
                )
                    .environmentObject(rm)
                    .presentationDetents(.init([.extraLarge]))
            } else {
                
            }
        }
}

