//
//  TranslationViewController.swift
//  LearnUrWords
//
//  Created by Admin on 11.07.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class TranslationViewController: UIViewController {
    
//MARK: Properties
    
    @IBOutlet weak var textField: UITextField!
    var translation: Translation?
    var word: Word?

    override func viewDidLoad() {
        super.viewDidLoad()
        if translation != nil {
            textField.text = translation?.translation
        }
    }
    
//MARK: Actions
    
    @IBAction func done() {
        if saveTranslation() {
            self.performSegue(withIdentifier: "unwindToTranslationList", sender: self)
        }
    }
    
    func saveTranslation() -> Bool {
        // Validation of required fields
        if textField.text!.isEmpty {
            let alert = UIAlertController(title: "Validation error", message: "Input the Translation!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        if translation == nil {
            translation = Translation()
            translation?.translation = textField.text
            word?.addToTranslations(translation!)
            CoreDataManager.instance.saveContext()
            return true
        }
        // Saving object
        translation?.translation = textField.text
        CoreDataManager.instance.saveContext()
        return true
    }
}
