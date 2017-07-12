//
//  Translation+CoreDataClass.swift
//  LearnUrWords
//
//  Created by Admin on 15.06.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import CoreData


public class Translation: NSManagedObject {

    convenience init () {
        self.init(entity: CoreDataManager.instance.entityFor(Name: "Translation"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
    
}
