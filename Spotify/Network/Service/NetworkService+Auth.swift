//
//  AuthService.swift
//  Spotify
//
//  Created by Hariharan Sundaram on 7/5/24.
//

import Foundation
import CryptoKit
import AuthenticationServices
import SwiftUI

struct OAuthPKCEParameters {
    let clientId: String
    let grantType: String
    let code: String
    let redirectURL: String
    let codeVerifier: String
}

protocol AuthNetworkServiceable {
    func fetchAuthToken(payload: OAuthPKCEParameters) async throws -> Result<AuthToken, NetworkError>
    func refreshAccessToken(refreshToken: String, clientId: String) async throws -> Result<AuthToken, NetworkError>
}

extension NetworkService: AuthNetworkServiceable {

    func fetchAuthToken(payload: OAuthPKCEParameters) async throws -> Result<AuthToken, NetworkError> {
        let result = try await networkServiceInterface.sendRequest(decodableType: AuthToken.self, networkRequest: AuthNetworkRequest.fetchAuthToken(payload: payload))
        return result
    }
    
    func refreshAccessToken(refreshToken: String, clientId: String) async throws -> Result<AuthToken, NetworkError> {
        let result = try await networkServiceInterface.sendRequest(decodableType: AuthToken.self, networkRequest: AuthNetworkRequest.refreshAuthToken(refreshToken: refreshToken, clientId: clientId))
        return result
    }
}
