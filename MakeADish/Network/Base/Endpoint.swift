//
//  Endpoint.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-05-05.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String]? { get }
    var body: [String: Any]? { get }
}

extension Endpoint {
    var baseURL: String {
        return "https://localhost:8080/"
    }
}
