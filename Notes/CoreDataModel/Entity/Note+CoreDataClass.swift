//
//  Note+CoreDataClass.swift
//  Notes
//
//  Created by Олег Федоров on 25.02.2022.
//
//

import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject {
    
    convenience init() {
        self.init(
            entity: CoreDataManager.shared.entityForName(entityName: "Note"),
            insertInto: CoreDataManager.shared.context
        )
    }
}
