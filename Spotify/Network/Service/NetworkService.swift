//
//  NetworkService.swift
//  Spotify
//
//  Created by Hariharan Sundaram on 7/7/24.
//

import Foundation

class NetworkService {
    let networkServiceInterface: NetworkServiceInterfaceable
    
    static let shared = NetworkService()
    
    init(networkServiceInterface: NetworkServiceInterfaceable = NetworkServiceInterface()) {
        self.networkServiceInterface = networkServiceInterface
    }
}
