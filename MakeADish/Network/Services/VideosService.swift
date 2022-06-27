//
//  VideosService.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-06-27.
//

import Foundation

protocol VideosServiceable {
    func getVideo(with id: String) async throws -> VideoResponse
}

struct VideosService: HTTPClient, VideosServiceable {
    func getVideo(with id: String) async throws -> VideoResponse {
        try await sendJsonRequest(endpoint: VideosEndpoint.getVideo(with: id), responseModel: VideoResponse.self)
    }
}
