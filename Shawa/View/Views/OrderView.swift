//
//  OrderView.swift
//  Shawa
//
//  Created by Alex on 18.08.23.
//

import SwiftUI

struct OrderView<AuthenticationManagerType: AuthenticationManager, OrderManagerType: OrderManager>: View {
    @EnvironmentObject private var orderManager: OrderManagerType
    @EnvironmentObject private var authenticationManager: AuthenticationManagerType
    
    @Environment(\.dismiss) private var dismiss
    @GestureState private var dragOffset = CGSize.zero
    
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
    @State private var sendButtonState = ActionButton.State.active(label: "Make an order")
    
    private var apartamentImage: String {
        if #available(iOS 16.0, *) {
            "door.right.hand.open"
        } else {
            "key"
        }
    }
    
    func loadFromModel() {
        enteredPhone = orderManager.currentOrder.user.phoneNumber ?? ""
        enteredStreet = orderManager.currentOrder.user.address.street ?? ""
        enteredHouse = orderManager.currentOrder.user.address.house ?? ""
        enteredApartament = orderManager.currentOrder.user.address.apartament ?? ""
        enteredComment = orderManager.currentOrder.comment ?? ""
    }
    
    func saveToModel() async {
//        switch orderSended {
//        case .sended:
//            orderManager.updatePhoneNumber("")
//            orderManager.updateComment("")
//            orderManager.updateAddress(street: "", house: "", apartament: "")
//            //FIXME: MB NOT NEDED orderManager .clearCart()
//            orderManager.updateUserID(authenticationManager.auth.uid)
//        case.notSended:
            orderManager.updatePhoneNumber(enteredPhone)
            orderManager.updateComment(enteredComment)
            orderManager.updateAddress(street: enteredStreet, house: enteredHouse, apartament: enteredApartament)
            orderManager.updateUserID(authenticationManager.auth.uid)
//        }
    }
    
    func closethisView () async {
        await saveToModel()
        dismiss()
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
                }.padding(.horizontal, .Constants.horizontalSafeArea)
                
                Text("Please provide some info to order:")
                    .foregroundColor(.deafultBrown)
                    .font(.montserratBold(size: 24))
                    .padding(.horizontal, .Constants.horizontalSafeArea)
                    .padding(.top, .Constants.standardSpacing)
                ZStack {
                    RoundedRectangle(cornerRadius: .Constants.blockCornerRadius)
                        .ignoresSafeArea(edges: .bottom)
                        .foregroundColor(.veryLightBrown2)
                    VStack (spacing: 0) {
                        Form {
                            formContent
                        }.defaultBackgroundHidden()
                        Divider().overlay(Color.lighterBrown)
                        HStack(alignment: .center, spacing: 0) {
                            Text("Grand total:")
                                .foregroundColor(.deafultBrown)
                                .font(.montserratBold(size: 24))
                                .padding(.trailing, .Constants.standardSpacing)
                                
                            Text(String(format: "%.2f BYN", orderManager.currentOrder.totalPrice))
                                .foregroundColor(.deafultBrown)
                                .font(.interBold(size: 20))
                                .frame(width: .Constants.OrderView.priceWidth, alignment: .trailing)
                        }
                            .padding(.horizontal, .Constants.horizontalSafeArea)
                            .padding(.bottom, .Constants.standardSpacing)
                            .padding(.vertical, .Constants.standardSpacing)
                    }.ignoresSafeArea( .container)
                }
            }
            
        }
        //FIXME: .scrollDismissesKeyboard(.interactively)
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
    
    @ViewBuilder
    var formContent: some View {
        PrettyTextField(
            text: $enteredPhone,
            label: "Phone",
            color: .lighterBrown,
            isSystemImage: true,
            image: "phone",
            width: nil,
            focusState: $focusedField,
            focusedValue: .phone,
            keyboardType: .phonePad,
            submitLabel: .next) {
                focusedField = .street
            }
        
        Section {
            PrettyTextField(
                text: $enteredStreet,
                label: "Street",
                color: .lighterBrown,
                isSystemImage: true,
                image: "mappin.and.ellipse",
                width: nil,
                focusState: $focusedField,
                focusedValue: .street,
                submitLabel: .next) {
                    focusedField = .house
                }
            HStack {
                PrettyTextField(
                    text: $enteredHouse,
                    label: "House",
                    color: .lighterBrown,
                    isSystemImage: true,
                    image: "building.2",
                    width: nil,
                    focusState: $focusedField,
                    focusedValue: .house,
                    submitLabel: .next) {
                        focusedField = .apartament
                    }
                PrettyTextField(
                    text: $enteredApartament,
                    label: "Apartament",
                    color: .lighterBrown,
                    isSystemImage: true,
                    image: apartamentImage,
                    width: nil,
                    focusState: $focusedField,
                    focusedValue: .apartament,
                    submitLabel: .done) {
                        focusedField = nil
                    }
            }
        } header: {
            Text("Address")
                .font(.main(size: 16))
                .foregroundColor(.deafultBrown)
        }.textCase(nil)
        Section {
            ZStack {
                RoundedRectangle(cornerRadius: .Constants.elementCornerRadius)
                    .stroke(lineWidth: .Constants.borderWidth)
                    .foregroundColor(.lighterBrown)
                TextEditor(text: $enteredComment)
                    .focused($focusedField, equals: .comment)
                    .font(.main(size: 14))
                    .foregroundColor(.lighterBrown)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                focusedField = nil
                            }
                        }
                    }
                    .padding(.horizontal, .Constants.standardSpacing)
            }.frame(minHeight: .Constants.lineElementHeight)
        } header: {
            Text("Comments to your order")
                .font(.main(size: 16))
                .foregroundColor(.deafultBrown)
        } .textCase(nil)
        ActionButton(state: sendButtonState) {
            sendButtonState = .loading(label: "Loading")
            Task {
                //TODO: check order sending correctly
                await saveToModel()
                do {
                    try await orderManager.sendCurrentOrder()
                    sendButtonState = .disabled(label: "Successfully placed an order")
                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                    await closethisView()
                } catch {
                    sendButtonState = .disabled(label: "Error: \(error.localizedDescription)")
                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                    sendButtonState = .active(label: "Make an order")
                }
            }
        }
    }
    
    var backgroundBody: some View {
        Rectangle().ignoresSafeArea().foregroundColor(.white)
    }
}

#Preview {
    @ObservedObject var am = AuthenticationManagerStub()
    @ObservedObject var rm = RestaurantManagerStub()
    @ObservedObject var om = OrderManagerStub()
    om.addOneOrderItem(Order.Item(menuItem: rm.allMenuItems.first!, availibleAdditions: rm.restaurants.value!.first!.ingredients))
    return OrderView<AuthenticationManagerStub, OrderManagerStub>()
        .environmentObject(am)
        .environmentObject(om)
}
