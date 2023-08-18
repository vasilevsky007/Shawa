//
//  SectionMenuView.swift
//  Shawa
//
//  Created by Alex on 14.03.23.
//

import SwiftUI

struct SectionMenuView: View {
    var displayingSection: Menu.Section
    var menuItems: Set<Menu.Item>
    @Binding var tappedItem: Menu.Item?
    @Environment(\.dismiss) private var dismissThisView
    @GestureState private var dragOffset = CGSize.zero
    
    private struct DrawingConstants {
        static let gridSpacing: CGFloat = 16
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            backgroundBody
            VStack(alignment: .leading) {
                Header(leadingIcon: "BackIcon", leadingAction: { dismissThisView() }){
                    CartView()
                }.padding(.horizontal, 24.5)
                
                Text(displayingSection.rawValue)
                    .foregroundColor(.deafultBrown)
                    .font(.montserratBold(size: 24))
                    .padding(.horizontal, 32)
                    .padding(.top, 8)
                
                ScrollView (.horizontal, showsIndicators: false) {
                    LazyHStack {
                        PrettyButton(text: "Filter", systemImage: "slider.vertical.3", isSwitch: true, unactiveColor: .lightBrown, onTap: {}).frame(width: 96, height: 40).padding(.leading, 24.5)
                        PrettyButton(text: "Popularity", isActive: true, onTap: {}).frame(width: 96, height: 40)
                        PrettyButton(text: "High Price", onTap: {}).frame(width: 88, height: 40)
                        PrettyButton(text: "Low Price", onTap: {}).frame(width: 88, height: 40)
                        PrettyButton(text: "Newest", onTap: {}).frame(width: 72, height: 40)
                        PrettyButton(text: "Oldest", onTap: {}).frame(width: 72, height: 40)
                    }.fixedSize()
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 30).ignoresSafeArea(edges: .bottom).padding(.top, 8).foregroundColor(.veryLightBrown2)
                    ScrollView {
                        LazyVGrid(columns: [GridItem(spacing: DrawingConstants.gridSpacing),GridItem(spacing: DrawingConstants.gridSpacing)], spacing: DrawingConstants.gridSpacing) {
                            ForEach(menuItems.filter({ $0.belogsTo == displayingSection }), id: \.self.id) { item in
                                Button {
                                    tappedItem = item
                                } label: {
                                    MenuItemCard(item)
                                        .aspectRatio(8/11, contentMode: .fit)
                                }
                                }
                            }.padding(.horizontal, 24)
                    }.padding(.top, 32)
    
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

//struct SectionMenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        @State var menu =  Menu()
//        @State var ti: Menu.Item?
//        SectionMenuView(displayingSection: .Shawarma, menu: $menu, tappedItem: $ti)
//            .previewDevice("iPhone 11 Pro")
//    }
//}
