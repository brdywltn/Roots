//
//  RootsApp.swift
//  Roots
//
//  Created by Brody Wilton on 12/03/2024.
//

import SwiftUI

@main
struct RootsApp: App {
    let persistenceController = PersistenceController.shared
    @State private var isActive: Bool = false   // Manage the splash screen visibility

    var body: some Scene {
        WindowGroup {
            if isActive {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .background(Color.softLimeGreen.edgesIgnoringSafeArea(.all))
            } else {
                SplashView()
                    .onAppear() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                self.isActive = true
                            }
                        }
                    }
            }
            
        }
    }
    
}
