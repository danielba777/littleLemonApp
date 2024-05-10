//
//  littleLemonAppApp.swift
//  littleLemonApp
//
//  Created by Daniel Bauer on 09.05.24.
//

import SwiftUI

@main
struct littleLemonAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            Onboarding()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
