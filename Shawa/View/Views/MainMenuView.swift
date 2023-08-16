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
    @State private var searchResultsShown = false
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                backgroundBody
                VStack {
                    headerBody.padding(.horizontal, 24)
                    contentBody.padding(.top, 8)
                }
            }.popover(item: $tappedItem) { item in
                MenuItemView(item) { selectedItem in
                    app.addOneOrderItem(selectedItem)
                }
            }
        }
            .onChange(of: searchBoxFocused) { beginFocused in
                if beginFocused {
                    withAnimation(.easeInOut(duration: 1)) {
                        searchResultsShown = true
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
            if searchResultsShown {
                searchResultsBody
                    .padding(.horizontal, 24.5)
                    .transition(.move(edge: .top).animation(.easeInOut(duration: 1))
                        .combined(with: .asymmetric(insertion: .opacity.animation(.easeIn(duration: 0.5).delay(0.5)),
                                                    removal: .opacity.animation(.easeOut(duration: 0.3)))))
            } else {
                mainMenuBody.transition(.move(edge: .bottom).animation(.easeInOut(duration: 1)))
            }
        }
    }
    
    var headerBody: some View {
        VStack {
            Header(leadingAction: firebase.logout) {
                //TODO: change leadingaction to open menu
                OrderView()
            }
            PrettyTextField(text: $enteredSearch, label: "Search for meals", submitLabel: .search, color: .lighterBrown, image: "SearchIcon",width: nil, height: 45, focusState: $searchBoxFocused, focusedValue: true )
                .overlay(alignment: .trailing) {
                    if searchResultsShown {
                        Button {
                            withAnimation(.easeInOut(duration: 1)) {
                                searchBoxFocused = false
                                searchResultsShown = false
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
        VStack{
            if searchResultsShown {
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
                            }.transition(.asymmetric(insertion: .push(from: .top), removal: .opacity).animation(.linear(duration: 1)))
                        }
                        Spacer(minLength: 0)
                    }
                }
            }
            Color.clear.frame(height: 0)
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
