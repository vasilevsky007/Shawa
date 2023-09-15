//
//  OrderView.swift
//  Shawa
//
//  Created by Alex on 18.08.23.
//

import SwiftUI
import ActionButton

struct OrderView: View {
    @Environment(\.dismiss) private var dismiss
    @GestureState private var dragOffset = CGSize.zero
    @EnvironmentObject var app: ShavaAppSwiftUI
    @EnvironmentObject var firebase: Firebase
    
    private enum FocusableField: Hashable {
        case phone, street, house, apartament, comment;
    }
    
    private enum OrderSended: Hashable {
        case sended, notSended;
    }
    
    @FocusState private var focusedField: FocusableField?
    
    @State private var enteredPhone = ""
    @State private var enteredStreet = ""
    @State private var enteredHouse = ""
    @State private var enteredApartament = ""
    @State private var enteredComment = ""
    @State private var orderSended = OrderSended.notSended
    
    func loadFromModel() {
        enteredPhone = app.orderUserdata.phoneNumber ?? ""
        enteredStreet = app.orderUserdata.address.street ?? ""
        enteredHouse = app.orderUserdata.address.house ?? ""
        enteredApartament = app.orderUserdata.address.apartament ?? ""
        enteredComment = app.orderComment
    }
    
    func updateModel() async {
        switch orderSended {
        case .sended:
            app.updatePhoneNumber("")
            app.updateOrderComment("")
            app.updateAddress(street: "", house: "", apartament: "")
            app.clearCart()
            app.updateOrderUID(firebase.achievedInfoAboutUser?.uid)
        case.notSended:
            app.updatePhoneNumber(enteredPhone)
            app.updateOrderComment(enteredComment)
            app.updateAddress(street: enteredStreet, house: enteredHouse, apartament: enteredApartament)
            app.updateOrderUID(firebase.achievedInfoAboutUser?.uid)
        }
        
    }
    
    
    
    func closethisView () async {
        await updateModel()
        dismiss()
    }
    
    private struct DrawingConstants {
        static let gridSpacing: CGFloat = 16
        static let pagePadding: CGFloat = 24
        static let padding: CGFloat = 8
        static let cornerRadius: CGFloat = 30
        static let headlineFontSize: CGFloat = 24
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            backgroundBody
            VStack(alignment: .leading) {
                Header(leadingIcon: "BackIcon", leadingAction: {
                    Task(priority: .userInitiated) {
                        await closethisView()
                    }
                }, noTrailingLink: true) {
                    Text("placeholder. will not be seen")
                }.padding(.horizontal, 24.5)
                
                Text("Please provide some info to order:")
                    .foregroundColor(.deafultBrown)
                    .font(.montserratBold(size: 24))
                    .padding(.horizontal, DrawingConstants.pagePadding)
                    .padding(.top, DrawingConstants.padding)
                ZStack {
                    RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                        .ignoresSafeArea(edges: .bottom)
                        .foregroundColor(.veryLightBrown2)
                    VStack (spacing: 0) {
                        Form {
                            PrettyTextField(
                                text: $enteredPhone,
                                label: "Phone",
                                submitLabel: .next,
                                submitAction: { focusedField = .street },
                                keyboardType: .phonePad,
                                color: .lighterBrown,
                                isSystemImage: true,
                                image: "phone",
                                width: nil,
                                focusState: $focusedField,
                                focusedValue: .phone
                            )
                            Section {
                                PrettyTextField(
                                    text: $enteredStreet,
                                    label: "Street",
                                    submitLabel: .next,
                                    submitAction: { focusedField = .house },
                                    color: .lighterBrown,
                                    isSystemImage: true,
                                    image: "mappin.and.ellipse",
                                    width: nil,
                                    focusState: $focusedField,
                                    focusedValue: .street
                                )
                                HStack {
                                    PrettyTextField(
                                        text: $enteredHouse,
                                        label: "House",
                                        submitLabel: .next,
                                        submitAction: { focusedField = .apartament },
                                        color: .lighterBrown,
                                        isSystemImage: true,
                                        image: "building.2",
                                        width: nil,
                                        focusState: $focusedField,
                                        focusedValue: .house
                                    )
                                    PrettyTextField(
                                        text: $enteredApartament,
                                        label: "Apartament",
                                        submitLabel: .done,
                                        submitAction: { focusedField = nil },
                                        color: .lighterBrown,
                                        isSystemImage: true,
                                        image: "door.right.hand.open",
                                        width: nil,
                                        focusState: $focusedField,
                                        focusedValue: .apartament
                                    )
                                }
                            } header: {
                                Text("Address")
                                    .font(.main(size: 16))
                                    .foregroundColor(.deafultBrown)
                            } .textCase(nil)
                            Section {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 1)
                                        .foregroundColor(.lighterBrown)
                                    TextEditor(text: $enteredComment)
                                        .focused($focusedField, equals: .comment)
                                        .font(.main(size: 14))
                                        .foregroundColor(.lighterBrown)
                                        .toolbar {
                                            if (focusedField == .comment){
                                                ToolbarItemGroup(placement: .keyboard) {
                                                    Spacer()
                                                    Button("Done") {
                                                        focusedField = nil
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.horizontal, DrawingConstants.padding)
                                } .frame(minHeight: 50)
                            } header: {
                                Text("Comments to your order")
                                    .font(.main(size: 16))
                                    .foregroundColor(.deafultBrown)
                            } .textCase(nil)
                            
                            ActionButton(state: $app.orderButtonState, onTap: {
                                app.orderButtonState = .loading(title: "Loading", systemImage: "")
                                Task(priority: .userInitiated) {
                                    await updateModel()
                                    do {
                                        try await firebase.sendOrder()
                                        orderSended = .sended
                                        app.orderButtonState = .disabled(title: "Successfully placed an order", systemImage: "checkmark")
                                        try! await Task.sleep(for: .seconds(2))
                                        app.orderButtonState = .enabled(title: "Make an order", systemImage: "")
                                        await closethisView()
                                    } catch {
                                        app.orderButtonState = .disabled(title: error.localizedDescription, systemImage: "exclamationmark.octagon")
                                        try! await Task.sleep(for: .seconds(2))
                                        app.orderButtonState = .enabled(title: "Make an order", systemImage: "")
                                    }
                                }
                            }, backgroundColor: .primaryBrown, foregroundColor: .white)
                        }
                            .scrollContentBackground(.hidden)
                        Divider().overlay(Color.lighterBrown)
                        HStack(alignment: .center, spacing: 0) {
                            Text("Grand total:")
                                .foregroundColor(.deafultBrown)
                                .font(.montserratBold(size: DrawingConstants.headlineFontSize))
                                .padding(.trailing, DrawingConstants.padding)
                                
                            Text(String(format: "%.2f BYN", app.orderPrice))
                                .foregroundColor(.deafultBrown)
                                .font(.interBold(size: 20))
                                .frame(width: 136, alignment: .trailing)
                        }
                            .padding(.horizontal, DrawingConstants.pagePadding)
                            .padding(.bottom, DrawingConstants.padding)
                            .padding(.vertical, DrawingConstants.padding)
                    }.ignoresSafeArea( .container)
                }
            }
            
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            
        }
        .highPriorityGesture(DragGesture().updating($dragOffset, body: { (value, _, _) in
            if(value.startLocation.x < 50 && value.translation.width > 100) {
                Task(priority: .userInitiated) {
                    await closethisView()
                }
            }
        }))
        .onAppear {
            loadFromModel()
        }
    }
    
    var backgroundBody: some View {
        Rectangle().ignoresSafeArea().foregroundColor(.white)
    }
}

struct OrderView_Previews: PreviewProvider {
    static var app = ShavaAppSwiftUI()
    static var previews: some View {
        app.clearCart()
        app.addOneOrderItem(Order.Item(item: Menu.Item(id: 1, belogsTo: .Shawarma, name: "Shawa1", price: 9.99, image: UIImage(named: "ShawarmaPicture")!.pngData()!, dateAdded: Date(), popularity: 2, ingredients: [.Cheese, .Chiken, .Onion], description: "jiqdlcmqc fqdwhj;ksm'qwd qfhdwoj;ks;qds ewoq;jdklso;ef"), additions: [.Cheese:2, .Beef:1, .Onion:-1, .FreshCucumbers:3, .Pork: 1]))
        app.addOneOrderItem(Order.Item(item: Menu.Item(id: 1, belogsTo: .Shawarma, name: "Shawa2", price: 6.99, image: UIImage(named: "ShawarmaPicture")!.pngData()!, dateAdded: Date(), popularity: 2, ingredients: [.Cheese, .Chiken, .Onion], description: "jiqdlcmqc fqdwhj;ksm'qwd qfhdwoj;ks;qds ewoq;jdklso;ef"), additions: [.Cheese:2, .Beef:1, .Onion:-1, .FreshCucumbers:3, .Pork: 1]))
        app.addOneOrderItem(Order.Item(item: Menu.Item(id: 1, belogsTo: .Shawarma, name: "Shawa2", price: 6.99, image: UIImage(named: "ShawarmaPicture")!.pngData()!, dateAdded: Date(), popularity: 2, ingredients: [.Cheese, .Chiken, .Onion], description: "jiqdlcmqc fqdwhj;ksm'qwd qfhdwoj;ks;qds ewoq;jdklso;ef"), additions: [.Cheese:2, .Beef:1, .Onion:-1, .FreshCucumbers:3, .Pork: 1]))

        
        return OrderView().environmentObject(app).previewDevice("iPhone 11 Pro")
    }
}
