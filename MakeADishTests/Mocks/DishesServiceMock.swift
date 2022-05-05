//
//  DishesServiceMock.swift
//  MakeADishTests
//
//  Created by Johan Forsell on 2022-05-05.
//

import Foundation
@testable import MakeADish

final class DishesServiceMock: Mockable, DishesServiceable {
    func addDish(_ dish: Dish) async throws -> Dish {
        return loadJSON(filename: "dish_example", type: Dish.self)
    }
    
    func getAllDishes() async throws -> [Dish] {
        return loadJSON(filename: "dishes_array_example", type: [Dish].self)
    }
}
