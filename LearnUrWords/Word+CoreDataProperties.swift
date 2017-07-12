//
//  Word+CoreDataProperties.swift
//  LearnUrWords
//
//  Created by Admin on 10.07.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import CoreData

extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word");
    }

    @NSManaged public var successfulAttempts: Int16
    @NSManaged public var word: String?
    @NSManaged public var lastShowingTime: NSDate?
    @NSManaged public var translations: NSSet?

}

// MARK: Generated accessors for translations
extension Word {

    @objc(addTranslationsObject:)
    @NSManaged public func addToTranslations(_ value: Translation)

    @objc(removeTranslationsObject:)
    @NSManaged public func removeFromTranslations(_ value: Translation)

    @objc(addTranslations:)
    @NSManaged public func addToTranslations(_ values: NSSet)

    @objc(removeTranslations:)
    @NSManaged public func removeFromTranslations(_ values: NSSet)

}
