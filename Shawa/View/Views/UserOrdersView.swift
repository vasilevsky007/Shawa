//
//  UserOrdersView.swift
//  Shawa
//
//  Created by Alex on 17.11.23.
//

import SwiftUI

struct UserOrdersView: View {
    @Environment(\.dismiss) private var dismiss
    @GestureState private var dragOffset = CGSize.zero
    @EnvironmentObject var app: ShavaAppSwiftUI
    @EnvironmentObject var firebase: Firebase
    
    func closeThisView () {
        dismiss()
    }
    
    private struct DrawingConstants {
        static let gridSpacing: CGFloat = 16
        static let pagePadding: CGFloat = 24
        static let padding: CGFloat = 8
        static let cornerRadius: CGFloat = 30
        static let headlineFontSize: CGFloat = 24
    }
    
    var backgroundBody: some View {
        Rectangle()
            .ignoresSafeArea()
            .foregroundColor(.white)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            backgroundBody
            VStack(alignment: .leading) {
                Header(leadingIcon: "BackIcon", leadingAction: {
                    closeThisView()
                }, noTrailingLink: true) {
                    Text("placeholder. will not be seen")
                }.padding(.horizontal, 24.5)
                
                Text("Your orders:")
                    .foregroundColor(.deafultBrown)
                    .font(.montserratBold(size: 24))
                    .padding(.horizontal, DrawingConstants.pagePadding)
                    .padding(.top, DrawingConstants.padding)
                ZStack {
                    RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                        .ignoresSafeArea(edges: .bottom)
                        .foregroundColor(.veryLightBrown2)
                    ScrollView {
                        LazyVStack (alignment: .leading, spacing: 8) {
                            ForEach(app.userOrders, id: \.self) { order in
                                UserOrder(order: order)
                            }
                        }.padding(DrawingConstants.pagePadding)
                    }
                    .refreshable {
                        //TODO: load orders from firebase
                        try? await firebase.getUserOrders()
                    }
                }.ignoresSafeArea( .container)
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            
        }
        .highPriorityGesture(DragGesture().updating($dragOffset, body: { (value, _, _) in
            if(value.startLocation.x < 50 && value.translation.width > 100) {
                closeThisView()
            }
        }))
        .task {
            //TODO: oad orders from firebase
        }
    }
}

#Preview {
    var app = ShavaAppSwiftUI()
    //    var fire = Firebase(app: app)
    
    return UserOrdersView().environmentObject(app)//.environmentObject(fire)
    
}
