//
//  Feeder_iOSApp.swift
//  Feeder-iOS
//
//  Created by Joe Diragi on 8/22/22.
//

import SwiftUI
import RealmSwift

@main
struct FeederApp: SwiftUI.App {
    static let realm = try! Realm()
    private var isFirstLaunch: Bool = true

    init() {
        if FeederApp.realm.object(ofType: Settings.self, forPrimaryKey: Constants.SETTINGSKEY) != nil {
            isFirstLaunch = false
        }
    }

    var body: some Scene {
        WindowGroup {
            if isFirstLaunch {
                WelcomeView()
            } else {
                WelcomeView() // TODO: HomeView()
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
