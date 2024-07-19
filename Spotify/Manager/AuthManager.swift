//
//  AuthManager.swift
//  Spotify
//
//  Created by Hariharan Sundaram on 7/8/24.
//

import Foundation

protocol AuthManageable {
    func validToken() async throws -> AuthToken
    func attemptTokenRefresh() async throws
}

actor AuthManager: AuthManageable {
    private var currentToken: AuthToken?
    private var refreshTask: Task<AuthToken, Error>?
    
    static let shared = AuthManager()
    
    let networkService: AuthNetworkServiceable
    let keyChainManager: KeychainManageable
    
    init(networkService: AuthNetworkServiceable = NetworkService(), keyChainManager: KeychainManageable = KeychainManager.shared) {
        self.networkService = networkService
        self.keyChainManager = keyChainManager
    }
    
    func fetchTokenFromKeychain() {
        guard let accessToken = keyChainManager.getValue(key: Constants.kAccessToken),
              let refreshToken = keyChainManager.getValue(key: Constants.kRefreshToken) else {
            return
        }
        currentToken = AuthToken(accessToken: accessToken, refreshToken: refreshToken)
    }
    
    func validToken() async throws -> AuthToken {
        if let task = refreshTask {
            return try await task.value
        }
        
        guard let token = currentToken else {
            throw SPError.missingAuthToken
        }
        return token
    }
    
    func attemptTokenRefresh() async throws {
        let updatedToken = try await refreshToken()
        self.currentToken = updatedToken
        keyChainManager.insert(key: Constants.kRefreshToken, value: updatedToken.refreshToken)
        keyChainManager.insert(key: Constants.kAccessToken, value: updatedToken.accessToken)
    }
    
    func refreshToken() async throws -> AuthToken {
        if let task = refreshTask {
             return try await task.value
        }
        let task = Task { () throws -> AuthToken in
            defer { refreshTask = nil }
            guard let refreshToken = currentToken?.refreshToken else {
                // TODO :- Perform logout
                throw SPError.missingAuthToken
            }
            return try await networkService.refreshAccessToken(refreshToken: refreshToken, clientId: AppEnvironment.clientId).get()
        }
        self.refreshTask = task
        return try await task.value
    }
    
    func resetAuthTokenKeychain() {
        keyChainManager.delete(key: Constants.kAccessToken)
        keyChainManager.delete(key: Constants.kRefreshToken)
    }
}
