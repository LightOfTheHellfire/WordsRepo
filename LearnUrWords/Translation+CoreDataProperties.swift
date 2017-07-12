//
//  Translation+CoreDataProperties.swift
//  LearnUrWords
//
//  Created by Admin on 10.07.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import CoreData

extension Translation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Translation> {
        return NSFetchRequest<Translation>(entityName: "Translation");
    }

    @NSManaged public var translation: String?
    @NSManaged public var word: Word?

}
