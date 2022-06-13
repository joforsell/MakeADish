//
//  User.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-06-12.
//

import Foundation

struct User: Codable, Identifiable {
    var id: UUID
    var username: String
    var comments: [Comment]
}

