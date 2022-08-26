//
//  Feeder_iOSApp.swift
//  Feeder-iOS
//
//  Created by Joe Diragi on 8/22/22.
//

import SwiftUI
import CoreData

@main
struct FeederApp: App {
    let persistenceController = PersistenceController.shared
    @FetchRequest(entity: Settings.entity(), sortDescriptors: [])
    private var settings: FetchedResults<Settings>

    var body: some Scene {
        WindowGroup {
            if settings.isEmpty {
                // If the settings are *not* created, user has *not* seen the welcome view
                WelcomeView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                // TODO: Show the home screen
                WelcomeView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}

struct AppButton: ButtonStyle {
    let color: Color

    public init(color: Color = .accentColor) {
        self.color = color
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.custom("button", size: 18.0))
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            .foregroundColor(.accentColor)
            .background(Color.accentColor.opacity(0.2))
            .cornerRadius(8)
    }
}
