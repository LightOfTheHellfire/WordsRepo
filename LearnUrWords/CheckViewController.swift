//
//  CheckViewController.swift
//  LearnUrWords
//
//  Created by Admin on 12.07.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class CheckViewController: UIViewController {
    
//MARK: Properties
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var translationTextField: UITextField!
    var translations: [String] = []
    var checkedTranslations: [String] = []
    var words: [Word] = []
    var filteredWords: [Word] = []
    let date = Date()
    var isWord = true
    let notify = Notify()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Settings.color
        filterContent()
        getWord()
        LocalNotification.instance.add()
    }
    
    
//MARK: Actions
    @IBAction func addTranslation() {
        if translationTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Validation error", message: "Input the Translation!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        translations.append(translationTextField.text!)
        translationTextField.text = ""
    }
    
//MARK: Working with Data
    func filterContent() {
        filteredWords = words.filter({(word: Word) -> Bool in
            if (word.translations?.count)! > 0 {
                if let time = word.lastShowingTime {
                    if Int(word.successfulAttempts) < (Settings.numberOfChecking - 2) && date.days(from: time as Date) >= 1{
                        return true
                    } else {
                        if date.days(from: time as Date) >= 1 {
                            if Int(word.successfulAttempts) < (Settings.numberOfChecking - 1) && (date.days(from: time as Date) > Settings.daysFromPenultCheck) {
                                return true
                            }
                            if Int(word.successfulAttempts) < (Settings.numberOfChecking) && (date.days(from: time as Date) > Settings.daysFromLastCheck) {
                                return true
                            }
                        }
                    }
                    return false
                } else {
                    return true
                }
            }
            return false
        })
        if filteredWords.count > Settings.maxWordsCount {
            for i in Settings.maxWordsCount...filteredWords.count {
                filteredWords.remove(at: i-1)
            }
        }
    }

    func getWord() {
        if filteredWords.isEmpty {
            let alert = UIAlertController(title: "No words left", message: "That's all for today!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                (_)in
                self.performSegue(withIdentifier: "unwindFromCheck", sender: self)
                }))
                self.present(alert, animated: true, completion: nil)
            return
        }
        translations = []
        checkedTranslations = []
        if (arc4random_uniform(2) == 0) {
            isWord = true
            wordLabel.text = filteredWords[0].word
            for tr in (filteredWords[0].translations?.allObjects as! [Translation]) {
                checkedTranslations.append(tr.translation!)
            }
        } else {
            isWord = false
            wordLabel.text = (filteredWords[0].translations?.allObjects[0] as! Translation).translation
            checkedTranslations.append(filteredWords[0].word!)
        }
    }
    
    func saveData(isSuccessful: Bool) {
        if isSuccessful {
            filteredWords[0].successfulAttempts += 1
        } else {
            if filteredWords[0].successfulAttempts > 0 {
                filteredWords[0].successfulAttempts -= 1
            }
        }
        filteredWords[0].lastShowingTime = Date() as NSDate?
        CoreDataManager.instance.saveContext()
        filteredWords.remove(at: 0)
    }
}

//MARK: Navigation
extension CheckViewController {
    @IBAction func unwindToCheckView(sender: UIStoryboardSegue) {
        if let source = sender.source as? ResultViewController {
            source.isSuccessful ? saveData(isSuccessful: true) : saveData(isSuccessful: false)
            getWord()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "CheckToResultSegue"
        {
            if let text = translationTextField.text {
                translations.append(text)
            }
            let destination = segue.destination as! ResultViewController
            destination.word = wordLabel.text!
            destination.translations = translations
            destination.checkedTranslations = checkedTranslations
        }
    }
}
