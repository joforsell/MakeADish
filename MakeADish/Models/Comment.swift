//
//  Comment.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-06-12.
//

import Foundation

struct Comment: Codable, Identifiable {
    var id: UUID
    var text: String
    var dish: Dish
    var user: User
    var timePosted: Date
    var lastEdited: Date
}
