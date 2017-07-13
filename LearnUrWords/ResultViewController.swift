//
//  ResultViewController.swift
//  LearnUrWords
//
//  Created by Admin on 12.07.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var word = String()
    var translations: [String] = []
    var checkedTranslations: [String] = []
    var isSuccessful = false
    @IBOutlet weak var translationsPickerView: UIPickerView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordLabel.text = "All meanings of \(word):"
        translationsPickerView.delegate = self
        translationsPickerView.dataSource = self
        checkAnswers()
        if isSuccessful {
            resultLabel.text = "Well Done!"
        } else {
            resultLabel.text = "You can do better!"
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
//MARK: UIPickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return checkedTranslations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let translation = checkedTranslations[row]
        return NSAttributedString(string: translation, attributes: [NSForegroundColorAttributeName:UIColor.red])
    }
    
    //MARK: Actions
    func checkAnswers() {
        var correctTranslations = 0
        for translation in translations {
            for checked in checkedTranslations {
                if translation.lowercased() == checked.lowercased() {
                    correctTranslations += 1
                }
            }
        }
        if correctTranslations > 0 {
            isSuccessful = true
        }
    }
}
