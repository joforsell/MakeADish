//
//  Video.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-06-27.
//

import Foundation

struct Video: Decodable {
    var videoId: String?
    var title: String
    var description: String
    var thumbnail: String
    
    enum CodingKeys: String, CodingKey {
        case snippet
        case thumbnails
        case high
        
        case title
        case description
        case thumbnail = "url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let snippetContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .snippet)
        
        // Parse title and description
        self.title = try snippetContainer.decode(String.self, forKey: .title)
        self.description = try snippetContainer.decode(String.self, forKey: .description)

        // Parse thumbnail image
        let thumbnailsContainer = try snippetContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .thumbnails)
        let highQualityContainer = try thumbnailsContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .high)
        self.thumbnail = try highQualityContainer.decode(String.self, forKey: .thumbnail)
    }
}
