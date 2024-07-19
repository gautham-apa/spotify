//
//  LoginViewModel.swift
//  Spotify
//
//  Created by Hariharan Sundaram on 7/6/24.
//

import Foundation
import CryptoKit

class LoginViewModel: ObservableObject {
    var codeVerifier: String?
    let authService: AuthNetworkServiceable
    
    init(authService: AuthNetworkServiceable = NetworkService()) {
        self.authService = authService
    }
    
    func constructAuthRedirectURL() -> URL? {
        guard var urlComponents = URLComponents(string: AppEnvironment.authURL) else { return nil }
        let scope = "user-read-private user-read-email"
        codeVerifier = generateCodeVerifier()
        
        let queryItems = [URLQueryItem(name: "response_type", value: "code"),
                          URLQueryItem(name: "client_id", value: AppEnvironment.clientId),
                          URLQueryItem(name: "scope", value: scope),
                          URLQueryItem(name: "code_challenge_method", value: "S256"),
                          URLQueryItem(name: "code_challenge", value: generateCodeChallenge(codeVerifier: codeVerifier)),
                          URLQueryItem(name: "redirect_uri", value: AppEnvironment.redirectURL)
        ]
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
    
    func signin(using urlWithToken: URL) async throws {
        let queryItems = URLComponents(string: urlWithToken.absoluteString)?.queryItems
        let code = queryItems?.filter({ $0.name == "code" }).first?.value
        guard let accessRequestCode = code, let accessCodeVerifier = codeVerifier else {
            throw SPError.emptyRequestCode
        }
        let response = try await authService.fetchAuthToken(
            payload: OAuthPKCEParameters(clientId: AppEnvironment.clientId,
                                         grantType: "authorization_code",
                                         code: accessRequestCode,
                                         redirectURL: AppEnvironment.redirectURL,
                                         codeVerifier: accessCodeVerifier)
        )
    }
    
    private func generateCodeVerifier() -> String {
        let length = 64
        let possible = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
        var codeVerifier = ""
        for _ in 1...length {
            codeVerifier.append(possible[Int.random(in: 1...1000000) % possible.count])
        }
        return codeVerifier
    }

    private func generateCodeChallenge(codeVerifier: String?) -> String? {
        guard let data = codeVerifier?.data(using: .utf8) else { return nil }
        let digest = SHA256.hash(data: data)
        let hashString = digest.data
        return hashString.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
    }
}
