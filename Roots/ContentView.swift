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
                        .foregroundColor(Color.richGrey)
                }
            PlantListView()
                .tabItem {
                    Image(systemName: "leaf.fill")
                    Text("Plants")
                        .foregroundColor(Color.richGrey)
                }
            ProfilePageView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                        .foregroundColor(Color.richGrey)
                }
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .background {
            Color.softLimeGreen.ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
