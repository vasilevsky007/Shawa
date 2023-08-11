//
//  MainMenuSection.swift
//  Shawa
//
//  Created by Alex on 12.03.23.
//

import SwiftUI

struct MainMenuSection: View {
    var section: Menu.Section
    var items: [Menu.Item]
    @Binding var tappedItem: Menu.Item?
    var body: some View {
        VStack{
            HStack{
                Text(section.rawValue)
                    .font(.main(size: 16))
                    .foregroundColor(.deafultBrown)
                Spacer()
                Text("See All")
                    .foregroundColor(.lightBrown)
                    .font(.main(size: 14))

            }
            ScrollView(Axis.Set.horizontal, showsIndicators: false) {
                LazyHStack{
                    ForEach(items, id: \.self.id) { item in
                        Button {
                            tappedItem = item
                        } label: {
                            MenuItemCard(item)
                                .frame(width: 155, height: 215)
                                .padding(.trailing, 8)
                        }
                    }
                }
            }.padding(.top, 12)
        }
    }
}

