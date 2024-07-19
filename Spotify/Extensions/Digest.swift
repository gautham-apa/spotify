//
//  Digest.swift
//  Spotify
//
//  Created by Hariharan Sundaram on 7/17/24.
//

import CryptoKit
import Foundation

extension Digest {
    var bytes: [UInt8] { Array(makeIterator()) }
    var data: Data { Data(bytes) }
}
