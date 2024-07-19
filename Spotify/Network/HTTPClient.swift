//
//  HTTPClient.swift
//  Spotify
//
//  Created by Hariharan Sundaram on 7/4/24.
//

import Foundation

protocol BaseNetworkServiceable {
    func sendRequest<T:Decodable>(urlRequest: URLRequest, responseModelType: T.Type) async throws -> (data: Data, response: HTTPURLResponse)
}

class HTTPClient: BaseNetworkServiceable {
    func sendRequest<T:Decodable>(urlRequest: URLRequest, responseModelType: T.Type) async throws -> (data: Data, response: HTTPURLResponse) {
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.noReponse
            }
            return (data, response)
        } catch(let error) {
            print("Unknown error occurred making network call. \(error)")
            throw NetworkError.unknown
        }
    }
}

