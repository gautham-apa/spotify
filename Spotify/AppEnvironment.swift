//
//  AppEnvironment.swift
//  Spotify
//
//  Created by Hariharan Sundaram on 7/6/24.
//

import Foundation


public struct AppEnvironment {
    static let baseURL = "api.spotify.com/v1"
    static let authURL = "https://accounts.spotify.com/authorize"
    static let tokenBaseURL = "accounts.spotify.com"
    static let clientId = "82c455c91a9f4fedaac7033fe0f3b9e2"
    static let redirectURL = "spotify-login://callback"
    static let urlScheme = "spotify-login"
}
