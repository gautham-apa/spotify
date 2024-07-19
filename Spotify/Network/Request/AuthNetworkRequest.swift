//
//  NetworkManager.swift
//  Spotify
//
//  Created by Hariharan Sundaram on 4/2/24.
//

import Foundation

enum AuthNetworkRequest {
    case fetchAuthToken(payload: OAuthPKCEParameters)
    case refreshAuthToken(refreshToken: String, clientId: String)
}

extension AuthNetworkRequest: NetworkRequestible {
    var host: String {
        return AppEnvironment.tokenBaseURL
    }
    
    var path: String {
        switch self {
        case .fetchAuthToken, .refreshAuthToken:
            return "/api/token"
        }
    }
    
    var queryParams: [URLQueryItem]? {
        switch self {
        case .fetchAuthToken, .refreshAuthToken:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchAuthToken, .refreshAuthToken:
            return .post
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .fetchAuthToken, .refreshAuthToken:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        }
    }
    
    var bodyEncodingType: BodyEncodingType {
        return .formURLEncoded
    }
    
    var body: [String : String]? {
        switch self {
        case .fetchAuthToken(let payload):
            return [
                "client_id": payload.clientId,
                "grant_type": payload.grantType,
                "code": payload.code,
                "redirect_uri": payload.redirectURL,
                "code_verifier": payload.codeVerifier,
            ]
        case let .refreshAuthToken(refreshToken, clientId):
            return [
                "client_id": clientId,
                "refresh_token": refreshToken,
                "grant_type": "refresh_token"
            ]
        }
    }
}
