//
//  NetworkService.swift
//  Spotify
//
//  Created by Hariharan Sundaram on 4/3/24.
//

import Foundation


protocol NetworkServiceInterfaceable {
    func sendRequest <T: Decodable>(decodableType: T.Type, networkRequest: NetworkRequestible) async throws -> Result<T, NetworkError>
    func sendRequestAuthorized <T: Decodable>(decodableType: T.Type, networkRequest: NetworkRequestible, retry: Bool) async throws -> Result<T, NetworkError>
    func setAuthManager(authManager: AuthManageable)
}

class NetworkServiceInterface: NetworkServiceInterfaceable {
    
    private var httpClient: BaseNetworkServiceable
    
    var authManager: AuthManageable?
    
    init(httpClient: BaseNetworkServiceable = HTTPClient()) {
        self.httpClient = httpClient
    }
    
    func setAuthManager(authManager: AuthManageable) {
        self.authManager = authManager
    }
    
    func sendRequest <T: Decodable>(decodableType: T.Type, networkRequest: NetworkRequestible) async throws -> Result<T, NetworkError> {
        let urlRequest = try await buildURLRequest(request: networkRequest, authorized: false)
        let response = try await httpClient.sendRequest(urlRequest: urlRequest, responseModelType: decodableType)
        return handleResponse(data: response.data, urlResponse: response.response, decodableType: decodableType)
    }
    
    func sendRequestAuthorized<T: Decodable>(decodableType: T.Type, networkRequest: any NetworkRequestible, retry: Bool = true) async throws -> Result<T, NetworkError> {
        let urlRequest = try await buildURLRequest(request: networkRequest, authorized: true)
        let response = try await httpClient.sendRequest(urlRequest: urlRequest, responseModelType: decodableType)
        let handledResult = handleResponse(data: response.data, urlResponse: response.response, decodableType: decodableType)
        
        switch handledResult {
        case .success: break
        case .failure(let error):
            if error == .unauthorized && retry {
                try await authManager?.attemptTokenRefresh()
                return try await sendRequestAuthorized(decodableType: decodableType, networkRequest: networkRequest, retry: false)
            }
        }
        
        return handledResult
    }
    
    func buildURLRequest(request: NetworkRequestible, authorized: Bool) async throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = request.scheme
        urlComponents.host = request.host
        urlComponents.path = request.path
        urlComponents.queryItems = request.queryParams
        
        guard let url = urlComponents.url else {
            throw NetworkError.urlBuildingFailed
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        guard let authToken = try await authManager?.validToken() else {
            throw SPError.missingAuthToken
        }
        
        if authorized {
            var headers = request.headers ?? [:]
            headers.updateValue("Bearer \(authToken.accessToken)", forKey: "Authorization")
            urlRequest.allHTTPHeaderFields = headers
        } else {
            urlRequest.allHTTPHeaderFields = request.headers
        }
        
        if let body = request.getBodyData() {
            urlRequest.httpBody = body
        }
        return urlRequest
    }

    func handleResponse<T: Decodable>(data: Data, urlResponse: HTTPURLResponse, decodableType: T.Type) -> Result<T, NetworkError> {
        switch urlResponse.statusCode {
        case 200...299:
            guard let decodedResponse = try? JSONDecoder().decode(decodableType, from: data) else {
                return .failure(.jsonDecodeFailed)
            }
            return .success(decodedResponse)
        case 401:
            return .failure(.unauthorized)
        default:
            print("Unhandled HTTP Status. \(urlResponse.statusCode)")
            return .failure(.unhandledHTTPStatus)
        }
    }
}
