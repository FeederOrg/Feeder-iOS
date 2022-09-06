//
//  WelcomeTests.swift
//  Feeder-iOSTests
//
//  Created by Joe Diragi on 9/5/22.
//

import XCTest
import RealmSwift
@testable import Feeder_iOS

final class WelcomeTests: FeederTestsBase {
    private let realm: Realm = try! Realm(queue: nil)
    
    override func setUp() {
        super.setUp()
        try! realm.write {
            realm.deleteAll()
        }
    }

    @MainActor
    func testCreateSettingsRealm() {
        // Setup values
        let viewModel = WelcomeView.ViewModel(realm: realm)
        let schedule = ["07:00:AM", "08:30:PM"]
        let amount: Float = 2.0
        let status = FeederStatus.needsSetup
        let hostname = "esp321432"
        let pet = Pet()
        pet.name = "Testy"
        let food = "Purina Cat Pro Food Cat Food"
        let room = "Living Room"
        // Apply values
        viewModel.setSchedule(schedule)
        viewModel.setFeederAmount(amount)
        viewModel.setFeederStatus(status)
        viewModel.setFeederHostname(hostname)
        viewModel.addPetToFeeder(pet)
        viewModel.setFeederFood(food)
        viewModel.setFeederRoom(room)
        // Write to realm
        viewModel.saveFeeder()
        // Verify
        let settings = realm.object(ofType: Settings.self, forPrimaryKey: Constants.SETTINGSKEY)
        let realmFeeder = settings!.feeders.first!
        XCTAssertNotNil(realmFeeder, "Realm Feeder not nil")
        XCTAssertEqual(realmFeeder.schedule.first, schedule[0], "Schedule match")
        XCTAssertEqual(realmFeeder.amountToDispense, amount, "Amount match")
        XCTAssertEqual(realmFeeder.status, status, "Status match")
        XCTAssertEqual(realmFeeder.hostname, hostname, "Hostname match")
        XCTAssertFalse(realmFeeder.pets.isEmpty, "realmFeeder.pets is not empty")
        XCTAssertEqual(realmFeeder.pets.first!.name, pet.name, "Pet name match")
        XCTAssertEqual(realmFeeder.food, food, "Food match")
        XCTAssertEqual(realmFeeder.room, room, "Room match")
    }
}
