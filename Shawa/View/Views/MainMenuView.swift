//
//  MainMenuView.swift
//  Shawa
//
//  Created by Alex on 11.03.23.
//

import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var app: ShavaAppSwiftUI
    @EnvironmentObject var firebase: Firebase
    @State private var enteredSearch: String = "" {
        mutating willSet {
            withAnimation {
                self.enteredSearch = newValue
            }
        }
    }
    @State private var tappedItem: Menu.Item? = nil;
    @FocusState private var searchBoxFocused: Bool
    private enum ShowingContent {
        case main, searchResults, menu
    }
    @State private var contentShowing = ShowingContent.main
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                backgroundBody
                VStack {
                    headerBody.padding(.horizontal, 24)
                    contentBody.padding(.top, 8)
                }
            }.sheet(item: $tappedItem) { item in
                MenuItemView(item) { selectedItem in
                    app.addOneOrderItem(selectedItem)
                }
            }
        }
            .navigationViewStyle(.stack)
            .onChange(of: searchBoxFocused) { beginFocused in
                if beginFocused {
                    withAnimation(.easeInOut(duration: 1)) {
                        contentShowing = .searchResults
                    }
                }
            }

    }
    
    var backgroundBody: some View {
        Rectangle().ignoresSafeArea().foregroundColor(.white)
    }
    
    var contentBody: some View {
        ZStack(alignment: .top) {
            Color.clear
            switch contentShowing {
            case .main:
                mainMenuBody.transition(.move(edge: .bottom).animation(.easeInOut(duration: 1)))
            case .searchResults:
                searchResultsBody
                    .padding(.horizontal, 24.5)
                    .transition(.move(edge: .top).animation(.easeInOut(duration: 1))
                        .combined(with: .asymmetric(insertion: .opacity.animation(.easeIn(duration: 0.5).delay(0.5)),
                                                    removal: .opacity.animation(.easeOut(duration: 0.2)))))
            case .menu:
                menuBody
                    .padding(.horizontal, 24.5)
                    .transition(.move(edge: .top).animation(.easeInOut(duration: 1))
                        .combined(with: .asymmetric(insertion: .opacity.animation(.easeIn(duration: 0.9).delay(0.1)),
                                                    removal: .opacity.animation(.easeOut(duration: 0.2)))))
            }
        }
    }
    
    var headerBody: some View {
        VStack {
            Header(leadingIcon: "MenuIcon") {
                withAnimation {
                    if contentShowing != .menu {
                        contentShowing = .menu
                    } else {
                        contentShowing = .main
                    }
                }
            } trailingLink: {
                CartView()
            }
            PrettyTextField(
                text: $enteredSearch,
                label: "Search for meals",
                color: .lighterBrown,
                image: "SearchIcon",
                width: nil,
                height: 45,
                focusState: $searchBoxFocused,
                focusedValue: true,
                submitLabel: .search )
                .overlay(alignment: .trailing) {
                    if contentShowing == .searchResults{
                        Button {
                            withAnimation(.easeInOut(duration: 1)) {
                                searchBoxFocused = false
                                contentShowing = .main
//                                enteredSearch = ""
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 20))
                                .foregroundColor(.lighterBrown)
                                .padding(.all)
                        }
                    }
                }
        }
        
    }
    
    var searchResultsBody: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading) {
                    Text((app.menuItems.filter({ $0.name.lowercased().contains(enteredSearch.lowercased()) })).isEmpty ? "Nothing found..." : "You may be looking for:")
                        .font(.main(size: 16))
                        .foregroundColor(.deafultBrown)
                    Color.clear.frame(height: 0)
                    ForEach(app.menuItems.filter({ $0.name.lowercased().contains(enteredSearch.lowercased()) })) { item in
                        Button {
                            tappedItem = item
                        } label: {
                            SearchItem(item)
                        }//FIXME: .transition(.asymmetric(insertion: .push(from: .top), removal: .opacity).animation(.linear(duration: 1)))
                    }
                    Spacer(minLength: 0)
                }
            }
            Color.clear.frame(height: 0)
        }
    }
    
    var menuBody: some View {
        return VStack(alignment: .leading) {
    
            NavigationLink {
                ProfileView()
            } label: {
                PrettyButton(text: "Profile", unactiveColor: .lightBrown, isActive: false, onTap: {})
                    .frame(height: 40)
            }
            NavigationLink {
                UserOrdersView()
            } label: {
                PrettyButton(text: "My orders", unactiveColor: .lightBrown, isActive: false, onTap: {})
                    .frame(height: 40)
            }
            PrettyButton(text: "Log out", systemImage: "rectangle.portrait.and.arrow.right", unactiveColor: .red, isActive: false) {
                firebase.logout()
            }
                .frame(height: 40)
        }
    }
    
    var mainMenuBody: some View {
        
        ZStack(alignment: .top) {
            Rectangle().cornerRadius(30).foregroundColor(.veryLightBrown)
            VStack {
                navigationBody
                fetchingProgressBody
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack {
                            ForEach(Menu.Section.allCases, id: \.self) { section in
                                NavigationLink {
                                    SectionMenuView(displayingSection: section, menuItems: app.menuItems, tappedItem: $tappedItem)
                                } label: {
                                    MainMenuSection(section: section,
                                                    items: app.menuItems.filter{ $0.belogsTo == section },
                                                    tappedItem: $tappedItem)
                                       .padding(.top, 12)
                                       .id(section)
                                       .onAppear(){
                                           app.navbar.actions[section] = { proxy.scrollTo(section, anchor: .topLeading) }
                                       }
                                }
                            }
                        }
                    }
                    .refreshable {
                        Task(priority: .userInitiated) {
                            await firebase.fetchMenu()
                        }
                    }
                }
            }.padding(.all, 24)
        }.ignoresSafeArea(edges:.bottom)
    }
     
    var fetchingProgressBody: some View {
        ZStack {
            if (app.isFetchingMenu) {
                ProgressView()
                    .tint(.deafultBrown)
                    .scaleEffect(1.5)
            }
            Color.clear.frame(width: 0, height: 0)
        }
    }
    
    var navigationBody: some View {
        ScrollView(Axis.Set.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach (Menu.Section.allCases, id: \.self) { section in
                    Text("   " + section.rawValue + "   ").padding(.all, 5)
                        .font(.main(size: 14))
                        .foregroundColor(app.navbar.activeButton == section ? .white : .lightBrown)
                        .background(app.navbar.activeButton == section ? Color.primaryBrown : Color.clear)
                        .clipShape(Capsule())
                        .onTapGesture {
                            app.navbar.click(on: section)
                        }
                }
            }.fixedSize()
        }.padding(.top, 8)
    }
    
}

//struct MainMenuView_Previews: PreviewProvider {
//    static var app1: ShavaAppSwiftUI?
//    static var fb: Firebase?
//    static var previews: some View {
//        app1 = ShavaAppSwiftUI()
//        fb = Firebase(app: app1!)
//
//        return MainMenuView().environmentObject(app1!).environmentObject(fb!).previewDevice("iPhone 11 Pro")
//    }
//}
