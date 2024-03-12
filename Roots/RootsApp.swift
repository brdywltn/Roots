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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
