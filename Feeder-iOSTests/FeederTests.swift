//
//  Feeder_iOSTests.swift
//  Feeder-iOSTests
//
//  Created by Joe Diragi on 8/22/22.
//

import XCTest
import RealmSwift
@testable import Feeder_iOS

class FeederTestsBase: XCTestCase {
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
}
