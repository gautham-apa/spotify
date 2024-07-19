//
//  LoginView.swift
//  Spotify
//
//  Created by Hariharan Sundaram on 7/6/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        VStack {
            Button("Sign in") {
                Task {
                    guard let authUrl = viewModel.constructAuthRedirectURL() else { return }
                    do {
                        // Perform the authentication and await the result.
                        let urlWithToken = try await webAuthenticationSession.authenticate(
                            using: authUrl,
                            callbackURLScheme: AppEnvironment.urlScheme
                        )
                        print(urlWithToken)
                        // Call the method that completes the authentication using the
                        // returned URL.
                        try await viewModel.signin(using: urlWithToken)
                    } catch {
                        // Respond to any authorization errors.
                    }
                }
            }
        }
    }
}
