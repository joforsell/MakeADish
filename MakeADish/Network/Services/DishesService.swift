//
//  DishesService.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-05-05.
//

import Foundation

protocol DishesServiceable {
    func getAllDishes() async throws -> [Dish]
    func addDish(_ dish: Dish) async throws -> Dish
}

struct DishesService: HTTPClient, DishesServiceable {
    func getAllDishes() async throws -> [Dish] {
        try await sendJsonRequest(endpoint: DishesEndpoint.allDishes, responseModel: [Dish].self)
    }
    
    func addDish(_ dish: Dish) async throws -> Dish {
        try await sendJsonRequest(endpoint: DishesEndpoint.addDish(dish), responseModel: Dish.self)
    }
}
