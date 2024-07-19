//
//  KeychainManager.swift
//  Spotify
//
//  Created by Hariharan Sundaram on 7/8/24.
//

import Foundation
import KeychainSwift

protocol KeychainManageable {
    func insert(key: String, value: String)
    func getValue(key: String) -> String?
    func delete(key: String)
}

class KeychainManager: KeychainManageable {
    let keyChain: KeychainSwift = KeychainSwift()
    
    static let shared = KeychainManager()
    
    func insert(key: String, value: String) {
        keyChain.set(value, forKey: key)
    }
    
    func getValue(key: String) -> String? {
        keyChain.get(key)
    }
    
    func delete(key: String) {
        keyChain.delete(key)
    }
}
