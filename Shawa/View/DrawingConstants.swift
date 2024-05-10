//
//  DrawingConstants.swift
//  Shawa
//
//  Created by Alex on 4.04.24.
//

import Foundation
extension CGFloat {
    struct Constants {
        static let elementCornerRadius: CGFloat = 10
        static let blockCornerRadius: CGFloat = 30
        static let lineElementHeight: CGFloat = 48
        static let borderWidth: CGFloat = 1
        static let doubleBorderWidth: CGFloat = 2
        
        static let horizontalSafeArea: CGFloat = tripleSpacing
        
        static let spinnerHeight: CGFloat = 30
        
        static let standardSpacing: CGFloat = 8
        static let halfSpacing: CGFloat = standardSpacing / 2
        static let doubleSpacing: CGFloat = 2 * standardSpacing
        static let tripleSpacing: CGFloat = 3 * standardSpacing
        static let quadripleSpacing: CGFloat = 4 * standardSpacing
        
        struct LoadableImage {
            static let errorImageSize: CGFloat = 64
        }
        
        struct PrettyTextField {
            static let imageSize: CGFloat = 20
            static let imagePadding: CGFloat = 14
            static let fieldsLeadingPadding: CGFloat = imageSize + (imagePadding * 2)
        }
        
        struct PrettyLabel {
            static let spacing: CGFloat = 14
            static let imageSize: CGFloat = 20
        }
        
        struct PrettyButton {
            static let imageInsets: CGFloat = standardSpacing * 2// + 6
        }
        
        struct PrettyEditButton {
            static let defaultHeight: CGFloat = 40
        }
        
        struct SegmentedProgressBar {
            static let borderWidth: CGFloat = 4
            static let barHeight: CGFloat = 12
            static let circleHeight: CGFloat = 24
            static let height: CGFloat = 40
        }
        
        struct Header {
            static let iconSize: CGFloat = tripleSpacing
            static let height: CGFloat = 32
        }
        
        struct MenuItemCard {
            static var cornerRadius: CGFloat = 15
        }
        
        struct SearchItem {
            static let imageSize: CGFloat = 64
            static let height: CGFloat = 80
        }
        
        struct MainMenuRestaurant {
            static let cardHeight: CGFloat = 232
            static let cardWidth: CGFloat = 160
        }
        
        struct OrderItem {
            static let imageSize: CGFloat = 96
            static let deleteIconSize: CGFloat = 32
        }
        
        struct OrderItemUnchangable {
            static let imageSize: CGFloat = 96
        }
        
        struct UserOrder {
            static let cornerRadius: CGFloat = 16
            static let priceWidth: CGFloat = 136
        }
        
        struct AuthoriseView {
            static let logoPadding: CGFloat = 64
            static let padFormWidth: CGFloat = 400
            
            struct Switch {
                static let bouncerInset: CGFloat = 4
                static let bouncerHeight: CGFloat = lineElementHeight + (bouncerInset * 2)
            }
        }
        
        struct MenuItemView {
            static let ingredientBoxHeight: CGFloat = 32
            static let ingredientBoxMinWidth: CGFloat = 100
            static let addButtonHeight: CGFloat = 60
            static let addButtonWidth: CGFloat = 130
            static let addButtonMaxWidth: CGFloat = 160
        }
        
        struct CartView {
            static let proceedOverlayWidth: CGFloat = 100
            static let proceedOverlayHeight: CGFloat = 50
        }
        
        struct OrderView {
            static let priceWidth: CGFloat = 136
        }
        
        struct ReceivedOrdersListView {
            static let filterItemHeight: CGFloat = 36
        }
        
        struct MenuEditorView {
            static let addButtonHeight: CGFloat = 32
        }
        
        struct RestaurantAdderView {
            static let addButtonMinWidth: CGFloat = 180
        }
    }
}
