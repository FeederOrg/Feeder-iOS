//
//  Pet.swift
//  Feeder-iOS
//
//  Created by Joe Diragi on 9/5/22.
//

import RealmSwift
import Foundation

/**
 *  Represents a pet
 *  - Parameter name: The pet's name
 *  - Parameter feeder: The feeder this pet will be eating from
 */
class Pet: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var name = ""
    @Persisted(originProperty: "pets") var feeder: LinkingObjects<Feeder>
}
