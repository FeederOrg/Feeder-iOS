//
//  WelcomeViewModel.swift
//  Feeder-iOS
//
//  Created by Joe Diragi on 9/5/22.
//

import SwiftUI
import RealmSwift

extension WelcomeView {
    @MainActor
    class ViewModel: ObservableObject {
        private var realm: Realm
        @Published var settings: Settings = Settings()
        @Published var feeder: Feeder = Feeder()
        
        init(realm: Realm = FeederApp.realm) {
            self.realm = realm
        }

        /// Set the schedule for the feeder we are setting up
        /// - Parameter schedule: A list of `String`s representing the time of day (`HH`:`MM`:`AM/PM`)
        func setSchedule(_ schedule: [String]) {
            schedule.forEach {
                feeder.schedule.append($0)
            }
        }

        /// Set the amount of food to be dispensed at a time
        /// - Parameter amount: The amount in cups to dispense
        func setFeederAmount(_ amount: Float) {
            feeder.amountToDispense = amount
        }

        /// Set the status of the device
        /// - Parameter status: The `FeederStatus` of the device
        func setFeederStatus(_ status: FeederStatus) {
            feeder.status = status
        }

        /// Set the device's hostname
        /// - Parameter hostname: The hostname of the device (no http:// or .local)
        func setFeederHostname(_ hostname: String) {
            feeder.hostname = hostname
        }

        /// Add a pet to the list of pets this feeder will be feeding.
        /// It's possible this device is dispensing food for only one
        /// pet.
        /// - Parameter pet: The pet to add to the list of pets this device will be feeding
        func addPetToFeeder(_ pet: Pet) {
            feeder.pets.append(pet)
        }

        /// Set the type of food that this device will be dispensing
        /// - Parameter food: The name of the food this device will be dispensing
        func setFeederFood(_ food: String) {
            // TODO: Implement predifined list of pet foods
            feeder.food = food
        }

        /// Set the room in which this device will be located
        /// - Parameter room: The room in which this device will be located
        func setFeederRoom(_ room: String) {
            feeder.room = room
        }

        /// Set the `Feeder` property on `Settings` and save it to the realm
        func saveFeeder() {
            settings.feeders.append(feeder)
            do {
                try realm.write {
                    realm.add(feeder)
                    realm.add(settings)
                }
            } catch {
                print("Couldn't connect to realm")
            }
        }
    }
}
