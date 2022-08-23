//
//  Feeder_iOSApp.swift
//  Feeder-iOS
//
//  Created by Joe Diragi on 8/22/22.
//

import SwiftUI

@main
struct Feeder_iOSApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
