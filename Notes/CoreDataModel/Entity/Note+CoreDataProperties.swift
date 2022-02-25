//
//  Note+CoreDataProperties.swift
//  Notes
//
//  Created by Олег Федоров on 25.02.2022.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var noteName: String?
    @NSManaged public var noteText: String?

}

extension Note : Identifiable {

}
