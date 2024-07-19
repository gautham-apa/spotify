//
//  SpotifyApp.swift
//  Spotify
//
//  Created by Hariharan Sundaram on 7/3/24.
//

import SwiftUI

@main
struct SpotifyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
