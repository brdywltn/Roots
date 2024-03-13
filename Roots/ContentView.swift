//
//  ContentView.swift
//  Roots
//
//  Created by Brody Wilton on 12/03/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    var body: some View {
        // Bottom navigation bar
        TabView {
            HomePageView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            PlantListView()
                .tabItem {
                    Image(systemName: "leaf.fill")
                    Text("Plants")
                }
            ProfilePageView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
            SettingsPageView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

#Preview {
    ContentView()
}
