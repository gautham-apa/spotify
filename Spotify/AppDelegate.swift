//
//  AppDelegate.swift
//  Spotify
//
//  Created by Hariharan Sundaram on 7/14/24.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        NetworkService.shared.networkServiceInterface.setAuthManager(authManager: AuthManager.shared)
        return true
    }
}
