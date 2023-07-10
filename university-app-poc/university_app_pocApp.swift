//
//  university_app_pocApp.swift
//  university-app-poc
//
//  Created by Taha Chaudhry on 11/07/2023.
//

import SwiftUI

@main
struct university_app_pocApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
