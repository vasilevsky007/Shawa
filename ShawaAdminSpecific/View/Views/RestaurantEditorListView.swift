//
//  MenuEditorView.swift
//  ShawaAdmin
//
//  Created by Alex on 2.05.24.
//

import SwiftUI

struct RestaurantEditorListView<RestaurantManagerType: RestaurantManager,
                                AuthenticationManagerType: AuthenticationManager>: View {
    @EnvironmentObject private var restaurantManager: RestaurantManagerType
    
    @State private var restaurantAdderPresented = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Restaurants")
                    .foregroundColor(.defaultBrown)
                    .font(.montserratBold(size: 24))
                    .padding(.top, .Constants.standardSpacing)
                    .padding(.horizontal, .Constants.horizontalSafeArea)
                VStack {
                    HStack {
                        if restaurantManager.restaurants.isLoading {
                            ProgressView()
                                .tint(.defaultBrown)
                        }
                        Spacer()
                        PrettyButton(text: "Add restaurant",
                                     systemImage: "plus.circle",
                                     fontsize: 16,
                                     unactiveColor: .defaultBrown,
                                     isActive: false) {
                            restaurantAdderPresented = true
                        }
                        .frame(height: .Constants.MenuEditorView.addButtonHeight)
                    }
                    .padding(.horizontal, .Constants.horizontalSafeArea)
                    List{
                        ForEach(restaurantManager.restaurants.value ?? []) { restaurant in
                            NavigationLink {
                                RestaurantEditorView<RestaurantManagerType, AuthenticationManagerType>(currentRestaurant: restaurant)
                            } label: {
                                VStack(alignment: .leading, spacing:0) {
                                    Text(restaurant.name)
                                        .foregroundStyle(.defaultBrown)
                                        .font(.mainBold(size: 24))
                                    HStack(spacing: 0) {
                                        Text("\(restaurant.sections.count) sections, ")
                                        Text( "\(restaurant.ingredients.count) ingredients, ")
                                        Text( "\(restaurant.menu.count) items in menu")
                                    }
                                        .foregroundStyle(.lightBrown)
                                        .font(.main(size: 14))
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparatorTint(.lighterBrown)
                        }
                        .onDelete { indicies in
                            for i in indicies {
                                if let restaurant = restaurantManager.restaurants.value?[i] {
                                    restaurantManager.remove(restaurant: restaurant)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
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
            .sheet(isPresented: $restaurantAdderPresented) {
                if #available(iOS 16.0, *) {
                    RestaurantNameEditorView<RestaurantManagerType>(
                        restaurant: .init(name: "", menu: [], ingredients: [], sections: []),
                        isNew: true
                    )
                        .presentationDetents(.init(arrayLiteral: .small))
                } else {
                    RestaurantNameEditorView<RestaurantManagerType>(
                        restaurant: .init(name: "", menu: [], ingredients: [], sections: []),
                        isNew: true
                    )
                }
            }
        }
    }
}

#Preview {
    RestaurantEditorListView<RestaurantManagerStub, AuthenticationManagerStub>()
        .background(.veryLightBrown2)
        .environmentObject(RestaurantManagerStub())
        .environmentObject(AuthenticationManagerStub())
}
