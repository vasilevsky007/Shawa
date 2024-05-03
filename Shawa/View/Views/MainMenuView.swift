//
//  MainMenuView.swift
//  Shawa
//
//  Created by Alex on 11.03.23.
//

import SwiftUI

struct MainMenuView<RestaurantManagerType: RestaurantManager,
                    OrderManagerType: OrderManager,
                    AuthenticationManagerType: AuthenticationManager>: View {
    @EnvironmentObject private var restaurantManager: RestaurantManagerType
    @EnvironmentObject private var orderManager: OrderManagerType
    @EnvironmentObject private var authenticationManager: AuthenticationManagerType
    
    @State private var tappedItem: MenuItem? = nil;
    @State private var showingSearch = false
    @State private var showingMenu = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                backgroundBody
                VStack {
                    headerBody.padding(.horizontal, .Constants.horizontalSafeArea)
                    if (showingMenu) {
                        dropMenuBody
                            .padding(.horizontal, .Constants.horizontalSafeArea)
                            .transition(
                                .move(edge: .top).animation(.easeInOut(duration: 1))
                                .combined(with:
                                        .asymmetric(
                                            insertion: .opacity.animation(.easeIn(duration: 0.9).delay(0.1)),
                                            removal: .opacity.animation(.easeOut(duration: 0.2))
                                        )
                                )
                            )
                    } else {
                        
                    }
                    VStack {
                        SearchArea<RestaurantManagerType>(tappedItem: $tappedItem, searchBoxFocused: $showingSearch).padding(.horizontal, .Constants.horizontalSafeArea)
                        if !showingSearch{
                            mainMenuBody
                                .transition(.move(edge: .bottom).animation(.easeInOut(duration: 1)))
                        }
                    }
                    .transition(.move(edge: .bottom).animation(.easeInOut(duration: 1)))
                }
            }.sheet(item: $tappedItem) { item in
                if let restaurant = restaurantManager.findRestaurant(withMenuItem: item) {
                    if #available(iOS 16.0, *) {
                        MenuItemView(item, belongsTo: restaurant) { selectedItem in
                            orderManager.addOneOrderItem(selectedItem)
                        }
                        .presentationDetents([.extraLarge])
                    } else {
                        MenuItemView(item, belongsTo: restaurant) { selectedItem in
                            orderManager.addOneOrderItem(selectedItem)
                        }
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    var backgroundBody: some View {
        Rectangle().ignoresSafeArea().foregroundColor(.white)
    }
    
    
    var headerBody: some View {
        Header(leadingIcon: "MenuIcon") {
            withAnimation {
                showingMenu.toggle()
            }
        } trailingLink: {
            CartView<AuthenticationManagerType, RestaurantManagerType, OrderManagerType>()
        }
    }
    
    
    var dropMenuBody: some View {
        return VStack(alignment: .leading) {
            
            NavigationLink {
                ProfileView<AuthenticationManagerType>()
            } label: {
                PrettyButton(text: "Profile", unactiveColor: .lightBrown, isActive: false, onTap: {})
                    .disabled(true)
                    .frame(height: .Constants.lineElementHeight)
            }
            NavigationLink {
                UserOrdersView<OrderManagerType, RestaurantManagerType>(userID: authenticationManager.auth.uid ?? "")
            } label: {
                PrettyButton(text: "My orders", unactiveColor: .lightBrown, isActive: false, onTap: {})
                    .disabled(true)
                    .frame(height: .Constants.lineElementHeight)
            }
            PrettyButton(text: "Log out", systemImage: "rectangle.portrait.and.arrow.right", unactiveColor: .red, isActive: false) {
                authenticationManager.logout()
            }
            .frame(height: .Constants.lineElementHeight)
        }
    }
    
    var mainMenuBody: some View {
        
        ZStack(alignment: .top) {
            Rectangle().cornerRadius(.Constants.blockCornerRadius).foregroundColor(.veryLightBrown)
            VStack {
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        LazyVStack {
                            fetchingProgressBody
                                .padding(.top, .Constants.tripleSpacing)
                            if let restaurants = restaurantManager.restaurants.value {
                                ForEach(restaurants) { restaurant in
                                    NavigationLink {
                                        RestaurantMenuView<AuthenticationManagerType, RestaurantManagerType, OrderManagerType>(restaurantId: restaurant.id, tappedItem: $tappedItem)
                                    } label: {
                                        MainMenuRestaurant(restaurant: restaurant, tappedItem: $tappedItem)
                                            .padding(.bottom, .Constants.doubleSpacing)
                                        
//FIXME: navigation stuff                                            .id(section)
//                                            .onAppear(){
//                                                app.navbar.actions[section] = { proxy.scrollTo(section, anchor: .topLeading) }
//                                            }
                                    }
                                }
                            }
                        }
                    }
                    .refreshControlColor(.defaultBrown)
                    .refreshable {
                        restaurantManager.loadRestaurants()
                    }
                    .task {
                        restaurantManager.loadRestaurants()
                    }
                }
            }.padding(.horizontal, .Constants.tripleSpacing)
        }.ignoresSafeArea(edges:.bottom)
    }
    
    var fetchingProgressBody: some View {
        
        ZStack {
            if (restaurantManager.restaurants.isLoading) {
                HStack(spacing: 0){
                    Spacer(minLength: 0)
                    ProgressView()
                        .tint(.defaultBrown)
                        .scaleEffect(1.5)
                    Spacer(minLength: 0)
                }.transition(.asymmetric(
                    insertion: .opacity.animation(.linear(duration: 1)),
                    removal: .identity))
            }
            Color.clear
        }
        .frame(height: restaurantManager.restaurants.isLoading ? .Constants.spinnerHeight : 0)
    }
    
    var navigationBody: some View {
        ScrollView(Axis.Set.horizontal, showsIndicators: false) {
            LazyHStack {
                //FIXME: navigation
                //                ForEach (Menu.Section.allCases, id: \.self) { section in
                //                    Text("   " + section.rawValue + "   ").padding(.all, 5)
                //                        .font(.main(size: 14))
                //                        .foregroundColor(app.navbar.activeButton == section ? .white : .lightBrown)
                //                        .background(app.navbar.activeButton == section ? Color.primaryBrown : Color.clear)
                //                        .clipShape(Capsule())
                //                        .onTapGesture {
                //                            app.navbar.click(on: section)
                //                        }
                //                }
            }.fixedSize()
        }.padding(.top, 8)
    }
    
}

#Preview {
    @ObservedObject var am = AuthenticationManagerStub()
    @ObservedObject var rm = RestaurantManagerStub()
    @ObservedObject var om = OrderManagerStub()
    
    return MainMenuView<RestaurantManagerStub, OrderManagerStub, AuthenticationManagerStub>().environmentObject(rm).environmentObject(om).environmentObject(am)
}
