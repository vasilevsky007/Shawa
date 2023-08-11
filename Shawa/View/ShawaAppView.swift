//
//  ShawaAppView.swift
//  Shawa
//
//  Created by Alex on 9.04.23.
//

import SwiftUI

struct ShawaAppView: View {
    @EnvironmentObject var app: ShavaAppSwiftUI
    
    var body: some View {
        ZStack {
            authirisation().transition(.opacity)
            mainmenu().transition(.opacity)
        }
        .preferredColorScheme(.light)
        .onAppear {
            UIRefreshControl.appearance().tintColor = UIColor(.lightBrown)
        }
    }
    
    @ViewBuilder
    func mainmenu() -> some View {
        if (app.isLoggedIn) {
            MainMenuView().transition(.opacity)
        } else {
            Color.clear
        }
    }
    
    @ViewBuilder
    func authirisation() -> some View {
        if (app.isLoggedIn) {
            Color.clear
        } else {
            AuthoriseView()
        }
    }

}
