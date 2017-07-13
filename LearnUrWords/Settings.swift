//
//  Settings.swift
//  LearnUrWords
//
//  Created by Admin on 12.07.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class Settings {
    static var numberOfChecking = 6
    static var maxWordsCount = 10
    static var daysFromPenultCheck = 6
    static var daysFromLastCheck = 20
    static var color = UIColor.gray
}

extension Date {
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
}
