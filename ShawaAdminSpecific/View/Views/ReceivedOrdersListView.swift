//
//  ReceivedOrdersListView.swift
//  ShawaAdmin
//
//  Created by Alex on 2.05.24.
//

import SwiftUI

struct ReceivedOrdersListView<RestaurantManagerType: RestaurantManager,
                              OrderManagerType: OrderManager,
                              AuthenticationManagerType: AuthenticationManager>: View {
    @EnvironmentObject private var restaurantManager: RestaurantManagerType
    @EnvironmentObject private var orderManager: OrderManagerType
    
    @State private var filterOptions: [Order.OrderState] = [.sended, .confirmed, .delivering]
    
    var ordersFiltered: [Order] {
        orderManager.allOrders.filter { order in
            guard let state = order.state else { return true }
            return filterOptions.contains(state)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Received orders")
                .foregroundColor(.defaultBrown)
                .font(.montserratBold(size: 24))
                .padding(.top, .Constants.standardSpacing)
                .padding(.horizontal, .Constants.horizontalSafeArea)
            
            FlowLayout(items: Order.OrderState.allCases) { option in
                PrettyButton(
                    text: LocalizedStringKey(option.rawValue),
                    systemImage: filterOptions.contains(option) ? "checkmark" : "xmark",
                    color: .primaryBrown,
                    unactiveColor: .defaultBrown,
                    isActive: filterOptions.contains(option)) {
                        if filterOptions.contains(option) {
                            filterOptions.removeAll(where: { $0 == option })
                        } else {
                            filterOptions.append(option)
                        }
                    }
                    .frame(height: .Constants.ReceivedOrdersListView.filterItemHeight)
            }.padding(.horizontal, .Constants.horizontalSafeArea)

            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: .Constants.doubleSpacing) {
                    ForEach(ordersFiltered) { order in
                        UserOrder<RestaurantManagerType, OrderManagerType>(isAdmin: true, order: order)
                        //TODO: добавить отображение ошибок при смене статуса.
                    }
                }
                .padding([.horizontal, .top], .Constants.horizontalSafeArea)
            }
            .background(
                .background,
                in: .rect(cornerRadius: .Constants.blockCornerRadius)
            )
            .background(
                .linearGradient(
                    colors: [.clear, .init(uiColor: .systemBackground)],
                    startPoint: .top, endPoint: .bottom
                ),
                in: .rect
            )
            .refreshable {
                restaurantManager.loadRestaurants()
            }
            .task {
                restaurantManager.loadRestaurants()
            }
        }
    }
}

#Preview {
    ReceivedOrdersListView<RestaurantManagerStub, OrderManagerStub, AuthenticationManagerStub>()
        .environmentObject(RestaurantManagerStub())
        .environmentObject(OrderManagerStub())
        .environmentObject(AuthenticationManagerStub())
}
