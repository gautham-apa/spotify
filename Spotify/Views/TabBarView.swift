//
//  TabBarView.swift
//  Spotify
//
//  Created by Hariharan Sundaram on 7/18/24.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "list.dash")
                }
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "square.and.pencil")
                }
            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "square.and.pencil")
                }
        }
    }
}
