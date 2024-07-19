//
//  NewRelease.swift
//  Spotify
//
//  Created by Hariharan Sundaram on 7/18/24.
//

import Foundation

struct NewRelease: Decodable {
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
