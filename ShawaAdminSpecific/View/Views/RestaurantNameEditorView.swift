//
//  RestaurantNameEditorView.swift
//  ShawaAdmin
//
//  Created by Alex on 10.05.24.
//

import SwiftUI

struct RestaurantNameEditorView<RestaurantManagerType: RestaurantManager>: View {
    @EnvironmentObject private var restaurantManager: RestaurantManagerType
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var enteredName: String
    @State private var error: Error? = nil
    
    private var isNew: Bool
    private var restaurant: Restaurant
    
    init(restaurant: Restaurant, isNew: Bool = false) {
        self.enteredName = restaurant.name
        self.restaurant = restaurant
        self.isNew = isNew
    }
    
    private func setError(to error: Error) {
        self.error = error
        Task {
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            withAnimation {
                self.error = nil
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack(alignment:.top) {
                Text(isNew ? "Adding new restaurant" : "Renaming \(restaurant.name)")
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.defaultBrown)
                    .font(.montserratBold(size: 24))
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
            
            
            if let error =  error {
                PrettyLabel("\(error.localizedDescription)", systemImage: "exclamationmark.triangle", font: .main(size: 10), color: .red)
            }
            
            HStack(spacing: 0) {
                Spacer(minLength: 0)
                Text("ID: \(restaurant.id)")
                    .font(.main(size: 10))
                    .foregroundStyle(.lighterBrown)
            }.padding(.top, error == nil ? .Constants.tripleSpacing : nil)
            
            HStack {
                PrettyButton(text: isNew ? "Add restaurant" : "Change name",
                             color: .primaryBrown,
                             unactiveColor: .lightBrown,
                             isActive: !enteredName.isEmpty,
                             infiniteWidth: true) {
                    guard !enteredName.isEmpty else {
                        setError(to:
                                    InputValidationError.fieldCannotBeEmpty(
                                        nameOfField: String(localized: "Restaurant name")
                                    )
                        )
                        return
                    }
                    var edited = restaurant
                    edited.name = enteredName
                    restaurantManager.add(restaurant: edited)
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
    @State var rm = RestaurantManagerStub()
    
    return Color.red
        .sheet(isPresented: .constant(true)) {
            
            if #available(iOS 16.0, *) {
                RestaurantNameEditorView<RestaurantManagerStub>(restaurant: rm.restaurants.value!.first!)
                    .environmentObject(rm)
                    .presentationDetents(.init([.small]))
            } else {
                // Fallback on earlier versions
            }
        }
}
