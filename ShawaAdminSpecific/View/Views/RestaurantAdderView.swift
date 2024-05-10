//
//  RestaurantAdderView.swift
//  ShawaAdmin
//
//  Created by Alex on 10.05.24.
//

import SwiftUI

struct RestaurantAdderView<RestaurantManagerType: RestaurantManager>: View {
    @EnvironmentObject private var restaurantManager: RestaurantManagerType
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var enteredName = ""
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 40))
                        .foregroundColor(.lighterBrown)
                }
            }
            Spacer(minLength: 0)
            PrettyTextField<Bool>(
                text: $enteredName,
                label: "Restaurant name",
                color: .defaultBrown,
                isSystemImage: true,
                image: "rectangle.and.paperclip",
                keyboardType: .default,
                submitLabel: .done)
            .padding(.bottom, .Constants.quadripleSpacing)
            HStack {
                PrettyButton(text: "Add restaurant",
                             color: .primaryBrown,
                             unactiveColor: .lightBrown,
                             isActive: !enteredName.isEmpty,
                             infiniteWidth: true) {
                    
                    let newRestaurant = Restaurant(name: enteredName, menu: [], ingredients: [], sections: [])
                    restaurantManager.add(restaurant: newRestaurant)
                    dismiss()
                }.frame(minWidth: .Constants.RestaurantAdderView.addButtonMinWidth)
                
                PrettyButton(text: "Cancel",
                             color: .red,
                             unactiveColor: .lightBrown,
                             isActive: true,
                             infiniteWidth: true) {
                    dismiss()
                }
            }
            .frame(height: .Constants.lineElementHeight)
        }
        .padding(.all, .Constants.horizontalSafeArea)
    }
}

#Preview {
    Color.red
        .sheet(isPresented: .constant(true)) {
            if #available(iOS 16.0, *) {
                RestaurantAdderView<RestaurantManagerStub>()
                    .environmentObject(RestaurantManagerStub())
                    .presentationDetents(.init([.small]))
            } else {
                // Fallback on earlier versions
            }
        }
}
