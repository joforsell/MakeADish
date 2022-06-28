//
//  Data+PrintJSON.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-06-28.
//

import Foundation

extension Data {
    func printJSON() {
        if let JSONString = String(data: self, encoding: String.Encoding.utf8) {
            print(JSONString)
        }
    }
}
