//
//  MeasuringUnit.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-06-12.
//

import Foundation

enum MeasuringUnit: String, Codable, CaseIterable {
    case teaspoon
    case tablespoon
    case ounce
    case cup
    case gallon
    
    var shorthand: String {
        switch self {
        case .teaspoon:
            return "tsp."
        case .tablespoon:
            return "tbsp."
        case .ounce:
            return "fl. oz."
        case .cup:
            return "cup"
        case .gallon:
            return "gal."
        }
    }
}
