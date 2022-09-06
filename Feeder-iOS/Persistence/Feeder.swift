//
//  Feeder.swift
//  Feeder-iOS
//
//  Created by Joe Diragi on 9/5/22.
//

import RealmSwift
import Foundation

/// Represents the status of the device
enum FeederStatus: String, PersistableEnum, CaseIterable {
    /// Device is connected and operational
    case connected = "Connected"
    /// Device cannot be found
    case disconnected = "Disconnected"
    /// Device is paired but not initialized
    case needsSetup = "Needs setup"
}

/// Represents a Feeder device
class Feeder: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: UUID
    /// A list of `String`s representing the times at which
    /// the feeder should go off (`HH`:`MM`:`AM/PM`)
    @Persisted var schedule: List<String>
    /// The amount of food (in cups) to be dispensed at a time
    @Persisted var amountToDispense: Float
    /// The status of our feeder
    @Persisted var status: FeederStatus
    /// The device's hostname (minus http:// & .local)
    @Persisted var hostname: String
    /// The pet's that will be eating from this feeder
    @Persisted var pets: List<Pet>
    /// The food that this feeder dispenses
    @Persisted var food: String
    /// The room that this feeder is located in
    @Persisted var room: String
}
