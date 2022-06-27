//
//  VideoResponse.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-06-27.
//

import Foundation

struct VideoResponse: Decodable {
    var videos: [Video]?
    
    enum CodingKeys: String, CodingKey {
        case videos = "items"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.videos = try container.decode([Video].self, forKey: .videos)
    }
}
