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
    static var dateComponents = Calendar.current.dateComponents(in: .current, from: Date())
    static var hour = 8
    static var minute = 0
    
    static func renewDate() {
        let date = Date()
        var components = Calendar.current.dateComponents(in: .current, from: date)
        components.day? += 1
        Settings.dateComponents = DateComponents(calendar: Calendar.current, timeZone: .current, year: components.year, month: components.month, day: components.day, hour: Settings.hour, minute: Settings.minute)
    }
}

extension Date {
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
}
