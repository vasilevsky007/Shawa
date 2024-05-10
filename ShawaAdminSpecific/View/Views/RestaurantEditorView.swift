//
//  RestaurantEditorView.swift
//  ShawaAdmin
//
//  Created by Alex on 10.05.24.
//

import SwiftUI

struct RestaurantEditorView<RestaurantManagerType: RestaurantManager,
                            AuthenticationManagerType: AuthenticationManager>: View {
    @EnvironmentObject private var restaurantManager: RestaurantManagerType
    @Environment(\.dismiss) private var dismiss
    
    @State private var restaurantNameEditorPresented = false
    @State private var editingSection: MenuSection?
    @State private var editingIngredient: Ingredient?
    @State private var editingMenuItem: MenuItem?
    
    @Namespace private var sectionsID
    @Namespace private var ingredientsID
    @Namespace private var menuItemsID
    
    var currentRestaurant: Restaurant
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: .Constants.standardSpacing) {
                Button {
                    dismiss()
                } label: {
                    Image(.backIcon)
                        .resizable(resizingMode: .stretch)
                        .frame(width: .Constants.Header.iconSize, height: .Constants.Header.iconSize)
                }
                
                Text(currentRestaurant.name)
                
                Spacer(minLength: 0)
                Button {
                    restaurantNameEditorPresented = true
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
            .font(.montserratBold(size: 24))
            .foregroundColor(.defaultBrown)
            .padding(.top, .Constants.standardSpacing)
            .padding(.horizontal, .Constants.horizontalSafeArea)
            
            VStack {
                ScrollViewReader { proxy in
                    if #available(iOS 16.4, *) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack (alignment: .top, spacing: .Constants.standardSpacing) {
                                scrollButton("Sections") {
                                    proxy.scrollTo(sectionsID, anchor: .top)
                                }
                                scrollButton("Ingredients") {
                                    proxy.scrollTo(ingredientsID, anchor: .top)
                                }
                                scrollButton("Menu Items") {
                                    proxy.scrollTo(menuItemsID, anchor: .top)
                                }
                            }
                            .padding(.horizontal, .Constants.horizontalSafeArea)
                        }
                        .scrollBounceBehavior(.basedOnSize)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack (alignment: .top, spacing: .Constants.standardSpacing) {
                                scrollButton("Sections") {
                                    proxy.scrollTo(sectionsID, anchor: .top)
                                }
                                scrollButton("Ingredients") {
                                    proxy.scrollTo(ingredientsID, anchor: .top)
                                }
                                scrollButton("Menu Items") {
                                    proxy.scrollTo(menuItemsID, anchor: .top)
                                }
                            }
                            .padding(.horizontal, .Constants.horizontalSafeArea)
                        }
                    }
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(alignment: .leading, spacing: .Constants.standardSpacing) {
                            HStack {
                                Text("Sections")
                                    .foregroundStyle(.defaultBrown)
                                Spacer(minLength: 0)
                                Button {
                                    //TODO: open editor
                                } label: {
                                    Image(systemName: "plus.circle")
                                        .foregroundStyle(.primaryBrown)
                                }
                            }
                                .font(.montserratBold(size: 24))
                                .padding(.horizontal, .Constants.horizontalSafeArea)
                                .id(sectionsID)
                            sectionsBody
                                .padding(.horizontal, .Constants.horizontalSafeArea)
                            dividerBody
                            
                            HStack {
                                Text("Ingredients")
                                    .foregroundStyle(.defaultBrown)
                                Spacer(minLength: 0)
                                Button {
                                    //TODO: open editor
                                } label: {
                                    Image(systemName: "plus.circle")
                                        .foregroundStyle(.primaryBrown)
                                }
                            }
                                .font(.montserratBold(size: 24))
                                .padding(.horizontal, .Constants.horizontalSafeArea)
                                .id(ingredientsID)
                            ingredientsBody
                                .padding(.horizontal, .Constants.horizontalSafeArea)
                            dividerBody
                            
                            HStack {
                                Text("Menu Items")
                                    .foregroundStyle(.defaultBrown)
                                Spacer(minLength: 0)
                                Button {
                                    //TODO: open editor
                                } label: {
                                    Image(systemName: "plus.circle")
                                        .foregroundStyle(.primaryBrown)
                                }
                            }
                                .font(.montserratBold(size: 24))
                                .padding(.horizontal, .Constants.horizontalSafeArea)
                                .id(menuItemsID)
                            menuItemsBody
                                .padding(.horizontal, .Constants.horizontalSafeArea)
                            dividerBody
                        }
                    }
                }
            }
            .padding([.top], .Constants.horizontalSafeArea)
            .background(
                .background,
                in: .rect(cornerRadius: .Constants.blockCornerRadius)
            )
            .background(
                .linearGradient(
                    colors: [.clear, .init(uiColor: .systemBackground)],
                    startPoint: .top, endPoint: .bottom
                ),
                in: .rect
            )
            .refreshable {
                restaurantManager.loadRestaurants()
            }
        }
        .background(.veryLightBrown2)
        .sheet(isPresented: $restaurantNameEditorPresented) {
            if #available(iOS 16.0, *) {
                RestaurantNameEditorView<RestaurantManagerType>(restaurant: currentRestaurant)
                    .presentationDetents(.init(arrayLiteral: .small))
            } else {
                RestaurantNameEditorView<RestaurantManagerType>(restaurant: currentRestaurant)
            }
        }
        .sheet(item: $editingSection) { section in
            Text(section.name)
        }
        .sheet(item: $editingIngredient) { ingredient in
            Text(ingredient.name)
        }
        .sheet(item: $editingMenuItem) { menuItem in
            Text(menuItem.name)
        }
        .navigationBarBackButtonHidden()
        .backGesture {
            dismiss()
        }
    }
}


// MARK: - Elements

private extension RestaurantEditorView {
    var sectionsBody: some View {
        Group {
            ForEach(currentRestaurant.sections) { section in
                Button {
                    editingSection = section
                } label: {
                    VStack(alignment: .leading, spacing: .Constants.standardSpacing) {
                        Text(section.name)
                            .font(.mainBold(size: 20))
                            .foregroundStyle(.defaultBrown)
                        
                        HStack(spacing: 0) {
                            Spacer(minLength: 0)
                            Text("ID: \(section.id)")
                                .font(.main(size: 10))
                                .foregroundStyle(.lighterBrown)
                        }
                        
                        Rectangle()
                            .frame(height: .Constants.borderWidth)
                            .foregroundStyle(.veryLightBrown2)
                            .padding(.bottom, .Constants.standardSpacing)
                    }
                    .multilineTextAlignment(.leading)
                }
                .swipeToDelete {
                    restaurantManager.remove(section, from: currentRestaurant)
                }
            }
        }
        .multilineTextAlignment(.leading)
    }
    
    var ingredientsBody: some View {
        Group {
            ForEach(currentRestaurant.ingredients) { ingredient in
                Button {
                    editingIngredient = ingredient
                } label: {
                    VStack(alignment: .leading, spacing: .Constants.standardSpacing) {
                        Text(ingredient.name)
                            .font(.mainBold(size: 20))
                            .foregroundStyle(.defaultBrown)
                        
                        HStack(spacing: 0) {
                            Text("Price:")
                            Spacer(minLength: 0)
                            Text(ingredient.cost, format: .currency(code: "BYN").presentation(.isoCode))
                        }
                        .font(.main(size: 16))
                        .foregroundStyle(.defaultBrown)
                        
                        HStack(spacing: 0) {
                            Spacer(minLength: 0)
                            Text("ID: \(ingredient.id)")
                                .font(.main(size: 10))
                                .foregroundStyle(.lighterBrown)
                        }
                        
                        Rectangle()
                            .frame(height: .Constants.borderWidth)
                            .foregroundStyle(.veryLightBrown2)
                            .padding(.bottom, .Constants.standardSpacing)
                    }
                    .multilineTextAlignment(.leading)
                }
                .swipeToDelete {
                    restaurantManager.remove(ingredient, from: currentRestaurant)
                }
            }
        }
    }
    
    var menuItemsBody: some View {
        Group {
            ForEach(currentRestaurant.menu) { menuItem in
                Button {
                    editingMenuItem = menuItem
                } label: {
                    VStack(alignment: .leading, spacing: .Constants.standardSpacing) {
                        Text(menuItem.name)
                            .font(.mainBold(size: 20))
                            .foregroundStyle(.defaultBrown)
                        
                        HStack(spacing: 0) {
                            Text("Price:")
                            Spacer(minLength: 0)
                            Text(menuItem.price, format: .currency(code: "BYN").presentation(.isoCode))
                        }
                        .font(.main(size: 16))
                        .foregroundStyle(.defaultBrown)
                        
                        HStack(alignment: .top, spacing: 0) {
                            Text("Belongs to:")
                            Spacer(minLength: 0)
                            Text(sectionNames(withIDs: menuItem.sectionIDs.sorted()))
                                .multilineTextAlignment(.trailing)
                        }
                        .font(.main(size: 16))
                        .foregroundStyle(.defaultBrown)
                        
                        HStack(alignment: .top, spacing: 0) {
                            Text("Ingredients included:")
                            Spacer(minLength: 0)
                            Text(ingredientNames(withIDs: menuItem.ingredientIDs.sorted()))
                                .multilineTextAlignment(.trailing)
                        }
                        .font(.main(size: 16))
                        .foregroundStyle(.defaultBrown)
                        
                        HStack(alignment: .top, spacing: 0) {
                            Text("Date added:")
                            Spacer(minLength: 0)
                            Text(menuItem.dateAdded.formatted(date: .numeric, time: .standard))
                                .multilineTextAlignment(.trailing)
                        }
                        .font(.main(size: 16))
                        .foregroundStyle(.defaultBrown)
                        
                        HStack(spacing: 0) {
                            Text("Popularity:")
                            Spacer(minLength: 0)
                            Text(menuItem.popularity.formatted())
                        }
                        .font(.main(size: 16))
                        .foregroundStyle(.defaultBrown)
                        
                        HStack(alignment: .top, spacing: 0) {
                            Text("Photo:")
                            Spacer(minLength: 0)
                            if let image = menuItem.image {
                                if #available(iOS 16.0, *) {
                                    Text(image, format: .url)
                                        .multilineTextAlignment(.trailing)
                                } else {
                                    Text(image.absoluteString)
                                        .multilineTextAlignment(.trailing)
                                }
                            } else {
                                Text("No image URL")
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                        .font(.main(size: 16))
                        .foregroundStyle(.defaultBrown)
                        
                        HStack(alignment: .top, spacing: 0) {
                            Text("Description:")
                            Spacer(minLength: 0)
                            Text(menuItem.description)
                        }
                        .font(.main(size: 16))
                        .foregroundStyle(.defaultBrown)
                        
                        HStack(spacing: 0) {
                            Spacer(minLength: 0)
                            Text("ID: \(menuItem.id)")
                                .font(.main(size: 10))
                                .foregroundStyle(.lighterBrown)
                        }
                        
                        Rectangle()
                            .frame(height: .Constants.borderWidth)
                            .foregroundStyle(.veryLightBrown2)
                            .padding(.bottom, .Constants.standardSpacing)
                    }
                    .multilineTextAlignment(.leading)
                }
                .swipeToDelete {
                    restaurantManager.remove(menuItem, from: currentRestaurant)
                }
            }
        }
    }
    
    var dividerBody: some View {
        Rectangle()
            .frame(height: .Constants.borderWidth)
            .foregroundStyle(.lighterBrown)
            .padding(.bottom, .Constants.standardSpacing)
    }
    
    func scrollButton(_ text: LocalizedStringKey, action: @escaping () -> Void) -> some View {
        Button {
            withAnimation {
                action()
            }
        } label: {
            Text(text)
                .font(.main(size: 16))
                .foregroundStyle(.white)
                .padding(.all, .Constants.standardSpacing)
                .padding(.horizontal, .Constants.standardSpacing)
                .background(.primaryBrown, in: .capsule)
        }
    }
}


// MARK: - Helper functions

private extension RestaurantEditorView {
    func sectionNames(withIDs IDs: [String]) -> String {
        IDs.map { id in
            currentRestaurant.sections
                .first(where: { $0.id == id })?.name ?? id
        }.joined(separator: ", ")
    }
    func ingredientNames(withIDs IDs: [String]) -> String {
        IDs.map { id in
            currentRestaurant.ingredients
                .first(where: { $0.id == id })?.name ?? id
        }.joined(separator: ", ")
    }
}

#Preview {
    @StateObject var rm = RestaurantManagerStub()
    @StateObject var am = AuthenticationManagerStub()
    
    return RestaurantEditorView<RestaurantManagerStub, AuthenticationManagerStub>(currentRestaurant: rm.restaurants.value!.first!)
        .environmentObject(rm)
        .environmentObject(am)
}
