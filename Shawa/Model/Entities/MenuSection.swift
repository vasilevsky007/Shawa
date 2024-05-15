//
//  Section.swift
//  Shawa
//
//  Created by Alex on 28.03.24.
//

import Foundation

struct MenuSection: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    
    init(name: String) {
        self.id = UUID().uuidString
        self.name = name
    }
}
