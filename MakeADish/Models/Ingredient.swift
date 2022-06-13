//
//  Ingredient.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-06-12.
//

import Foundation

struct Ingredient: Codable, Identifiable {
    var id: UUID
    var name: String
    var volume: Double
    var unit: MeasuringUnit
}
