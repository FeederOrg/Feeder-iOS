//
//  Settings.swift
//  Feeder-iOS
//
//  Created by Joe Diragi on 9/5/22.
//

import RealmSwift
import Foundation

class Settings: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String = "SettingsKey"
    @Persisted var feeders: List<Feeder> = List<Feeder>()
}
