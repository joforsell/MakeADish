//
//  VideosEndpoint.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-06-27.
//

import Foundation

enum VideosEndpoint {
    case getVideo(with: String)
}

extension VideosEndpoint: Endpoint {
    var baseURL: String {
        return "https://www.googleapis.com/youtube/v3/"
    }
    
    var path: String {
        switch self {
        case .getVideo(let id):
            return "videos?part=snippet&id=\(id)&key=\(Keys.YOUTUBE_API)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getVideo:
            return .get
        }
    }
    
    var header: [String: String]? {
        switch self {
        case .getVideo:
            return [
                "Content-Type": "application/json"
            ]
        }
    }
    
    var body: [String: Any]? {
        switch self {
        case .getVideo:
            return nil
        }
    }
}
