//
//  SearchArea.swift
//  Shawa
//
//  Created by Alex on 30.03.24.
//

import SwiftUI

struct SearchArea<RestaurantManagerType: RestaurantManager>: View {
    @Binding var tappedItem: MenuItem?
    @Binding var searchBoxFocused: Bool
    
    @FocusState private var focused: Bool
    
    @EnvironmentObject private var restaurantManager: RestaurantManagerType
    @State private var enteredSearch: String = ""
    
    var body: some View {
        VStack {
            PrettyTextField(
                text: $enteredSearch,
                label: "Search for meals",
                color: .lighterBrown,
                image: "SearchIcon",
                width: nil,
                height: .Constants.lineElementHeight,
                focusState: $focused,
                focusedValue: true,
                submitLabel: .search )
            .overlay(alignment: .trailing) {
                if searchBoxFocused {
                    Button {
                        withAnimation {
                            enteredSearch = ""
                            focused = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 20))
                            .foregroundColor(.lighterBrown)
                            .padding(.all)
                    }
                }
            }
            if searchBoxFocused {
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(alignment: .leading) {
                        Text((restaurantManager.allMenuItems.filter({ $0.name.lowercased().contains(enteredSearch.lowercased()) })).isEmpty ? "Nothing found..." : "You may be looking for:")
                            .font(.main(size: 16))
                            .foregroundColor(.defaultBrown)
                        Color.clear.frame(height: 0)
                        ForEach(restaurantManager.allMenuItems.filter({ $0.name.lowercased().contains(enteredSearch.lowercased()) })) { item in
                            Button {
                                tappedItem = item
                            } label: {
                                SearchItem(item)
                            }
                        }
                        Spacer(minLength: 0)
                    }
                }
                .transition(.move(edge: .top).animation(.easeInOut(duration: 1))
                    .combined(with: .asymmetric(insertion: .opacity.animation(.easeIn(duration: 0.5).delay(0.5)),
                                                removal: .opacity.animation(.easeOut(duration: 0.2)))))
            }
        }
        .onChange(of: focused) { focused in
            withAnimation {
                searchBoxFocused = focused
            }
        }
        .animation(.default, value: enteredSearch)
    }
}

//#Preview {
//    @State var item: MenuItem?
//    
//    return SearchArea<RestaurantManagerStub>(tappedItem: $item).environmentObject(RestaurantManagerStub())
//}
