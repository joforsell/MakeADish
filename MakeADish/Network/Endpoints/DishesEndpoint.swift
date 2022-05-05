//
//  DishesEndpoint.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-05-05.
//

import Foundation

enum DishesEndpoint {
    case allDishes
    case addDish(_: Dish)
}

extension DishesEndpoint: Endpoint {
    var path: String {
        switch self {
        case .allDishes:
            return "dishes"
        case .addDish:
            return "dishes/add"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .allDishes:
            return .get
        case .addDish:
            return .post
        }
    }
    
    var header: [String: String]? {
        switch self {
        case .allDishes, .addDish:
            return [
                "Content-Type": "application/json"
            ]
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .allDishes:
            return nil
        case .addDish(let dish):
            return dish.dictionary
        }
    }
}
