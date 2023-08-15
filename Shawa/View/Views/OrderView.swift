//
//  OrderView.swift
//  Shawa
//
//  Created by Alex on 12.08.23.
//

import SwiftUI

struct OrderView: View {
    @Environment(\.dismiss) private var dismissThisView
    @GestureState private var dragOffset = CGSize.zero
    @EnvironmentObject var app: ShavaAppSwiftUI
    
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
                Header(leadingIcon: "BackIcon", leadingAction: { dismissThisView() }).padding(.horizontal, 24.5)
                
                Text("Your order:")
                    .foregroundColor(.deafultBrown)
                    .font(.montserratBold(size: 24))
                    .padding(.horizontal, DrawingConstants.pagePadding)
                    .padding(.top, DrawingConstants.padding)
                ZStack {
                    RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                        .ignoresSafeArea(edges: .bottom)
                        .foregroundColor(.veryLightBrown2)
                    VStack (alignment: .listRowSeparatorTrailing, spacing: 0) {
                        ScrollView {
                            LazyVStack (spacing: DrawingConstants.gridSpacing) {
                                ForEach(Array(app.cartItems.keys.sorted(by: { item1, item2 in
                                    if item1.item.name != item2.item.name {
                                        return item1.item.name < item2.item.name
                                    } else {
                                        return item1.id.description < item2.id.description
                                    }
                                }))) {cartItem in
                                    OrderItem(cartItem)
                                }
                            }
                            .padding(.top, DrawingConstants.pagePadding)
                            .padding(.horizontal, DrawingConstants.pagePadding)
                        }
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
                            .padding(.vertical, DrawingConstants.padding)
                    }.ignoresSafeArea(edges: .bottom)
                }
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            
        }
        .highPriorityGesture(DragGesture().updating($dragOffset, body: { (value, _, _) in
            if(value.startLocation.x < 50 && value.translation.width > 100) {
                dismissThisView()
            }
        }))
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
