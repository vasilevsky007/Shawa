//
//  IosApp.swift
//  Shawa
//
//  Created by Alex on 10.03.23.
//

import SwiftUI
import FirebaseCore


@main
struct IosApp: App {
//    @State var appViewModel: ShavaAppSwiftUI
//    @State var appFirebase: Firebase
    
    init () {
        FirebaseApp.configure()
//        let temp = ShavaAppSwiftUI()
//        appViewModel = temp
//        appFirebase = Firebase(app: temp)
    }
    
    var body: some Scene {
        WindowGroup {
            EmptyView()
                .task {

                }
//        ShawaAppView()
//            .environmentObject(appFirebase)
//            .environmentObject(appViewModel)
        }
    }
}
