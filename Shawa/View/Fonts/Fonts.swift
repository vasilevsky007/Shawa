//
//  Fonts.swift
//  Shawa
//
//  Created by Alex on 10.03.23.
//

import SwiftUI

extension Font {
    static func interBold (size fontSize: CGFloat) -> Font {
        .custom("Inter-Bold", size: fontSize)
    }
    static func montserratBold (size fontSize: CGFloat) -> Font {
        .custom("MontserratThin-Bold", size: fontSize)
    }
    static func main (size fontSize: CGFloat) -> Font {
        .custom("DMSans-Regular", size: fontSize)
    }
    static func mainBold (size fontSize: CGFloat) -> Font {
        .custom("DMSans-Bold", size: fontSize)
    }
    static func logo (size fontSize: CGFloat) -> Font {
        .custom("tangak", size: fontSize)
    }
    static func printAllFonts() {
        for family in UIFont.familyNames {
            print(family)
            for names in UIFont.fontNames(forFamilyName: family){
                 print("== \(names)")
            }
        }
    }
}
