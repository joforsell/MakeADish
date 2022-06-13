//
//  Dish.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-05-05.
//

import Foundation

struct Dish: Codable, Identifiable {
    var id: UUID
    var title: String
    var description: String
    var videoId: String
    var comments: [Comment]?
    var ingredients: [Ingredient]?
    var tags: [String]
    var ratings: [Int]
}
