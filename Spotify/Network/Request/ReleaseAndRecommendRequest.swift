//
//  ReleaseAndRecommendRequest.swift
//  Spotify
//
//  Created by Hariharan Sundaram on 7/18/24.
//

import Foundation

enum ReleaseAndRecommendRequest {
    case fetchNewReleases(limit: Int, offset: Int)
    
}

extension ReleaseAndRecommendRequest: NetworkRequestible {
    var path: String {
        switch self {
        case .fetchNewReleases:
            return "/browse/new-releases"
        }
    }
    
    var queryParams: [URLQueryItem]? {
        switch self {
        case let .fetchNewReleases(limit, offset):
            return [URLQueryItem(name: "limit", value: String(limit)),
                    URLQueryItem(name: "offset", value: String(offset))]
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String]? {
        switch self {
        case .fetchNewReleases:
            return nil
        }
    }
    
    var body: [String : String]? {
        return nil
    }
}
