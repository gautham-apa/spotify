//
//  AuthToken.swift
//  Spotify
//
//  Created by Hariharan Sundaram on 7/8/24.
//

import Foundation

struct AuthToken: Decodable {
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
