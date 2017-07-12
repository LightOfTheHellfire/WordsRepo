//
//  Notify.swift
//  LearnUrWords
//
//  Created by Admin on 08.07.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import UserNotifications

class Notify: NSObject, UNUserNotificationCenterDelegate {
    let center = UNUserNotificationCenter.current()
    var viewController: ViewController?
    var checkViewController: CheckViewController?
    var isActive = false
    
    override init() {
        super.init()
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Notification Center autorization request failure")
            }
        }
        
    }
    
    func add() {
        if isActive {
            return
        }
        let content = UNMutableNotificationContent()
        content.title = "Learn Your Words"
        content.body = "You have a words to learn!"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "LearnUrWords"
        
        let date = Date()
        let triggerDate = date.addingTimeInterval(10)
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        
        let identifier = "LearnUrWords"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)

        let noteCategory = UNNotificationCategory(identifier: "LearnUrWords", actions: [], intentIdentifiers: [], options: [])
        center.setNotificationCategories([noteCategory])
        
        center.delegate = self
        center.add(request)
        isActive = true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        isActive = false
        //viewController = CheckViewController()
        //viewController?.present(viewController!, animated: true, completion: nil)
    }
    
}
