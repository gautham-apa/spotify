//
//  NetworkRequestible.swift
//  Spotify
//
//  Created by Hariharan Sundaram on 7/2/24.
//

import Foundation

enum BodyEncodingType {
    case json
    case formURLEncoded
}

protocol NetworkRequestible {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var queryParams: [URLQueryItem]? { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: [String: String]? { get }
    var bodyEncodingType: BodyEncodingType { get }
    
    func getBodyData() -> Data?
}

extension NetworkRequestible {
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return AppEnvironment.baseURL
    }
    
    var bodyEncodingType: BodyEncodingType {
        return .json
    }
    
    func getBodyData() -> Data? {
        guard let body = body else { return nil }
        switch bodyEncodingType {
        case .json:
            return try? JSONSerialization.data(withJSONObject: body)
        case .formURLEncoded:
            var components = URLComponents()
            components.queryItems = body.map { URLQueryItem(name: $0.key, value: $0.value) }
            return components.url?.query?.data(using: .utf8)
        }
    }
}
