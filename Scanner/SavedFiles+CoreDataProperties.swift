//
//  SavedFiles+CoreDataProperties.swift
//  Scanner
//
//  Created by Petros Gabrielyan on 17.01.24.
//
//

import Foundation
import CoreData


extension SavedFiles {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedFiles> {
        return NSFetchRequest<SavedFiles>(entityName: "SavedFiles")
    }

    @NSManaged public var thumb: Data?
    @NSManaged public var name: String?
    @NSManaged public var date: String?

}

extension SavedFiles : Identifiable {

}
