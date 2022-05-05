//
//  Encodable+ToDictionary.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-05-05.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}
