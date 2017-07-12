//
//  EditViewController.swift
//  LearnUrWords
//
//  Created by Admin on 10.07.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController, UITableViewDelegate {

//MARK: Properties
    
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var word: Word?
    var translations: [Translation]?
    let textCellIdentifier = "TextCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        if word != nil {
            wordTextField.text = word?.word
        }
    }

//MARK: Actions
    
    @IBAction func addNewTranslation() {
        if saveWord() {
            performSegue(withIdentifier: "EditTranslationSegue", sender: nil)
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func save(_ sender: UIBarButtonItem) {
        if saveWord() {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func saveWord() -> Bool {
        // Validation of required fields
        if wordTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Validation error", message: "Input the Word!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        // Creating object
        if word == nil {
            word = Word()
        }
        
        word?.word = wordTextField.text
        CoreDataManager.instance.saveContext()
        return true
    }
    
//MARK: TableView didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if saveWord() {
            let translation = word?.translations?.allObjects[indexPath.row] as? Translation
            performSegue(withIdentifier: "EditTranslationSegue", sender: translation)
        }
    }
    @IBAction func unwindToTranslationList(sender: UIStoryboardSegue) {
        tableView.reloadData()
    }
}

//MARK: Navigation
extension EditViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "EditTranslationSegue",
        let destination = segue.destination as? TranslationViewController
        {
            destination.word = word
            if let translation = sender as? Translation {
                destination.translation = translation
            }
        } 
    }
}



//MARK: TableView
extension EditViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = word?.translations?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = (word?.translations?.allObjects[row] as! Translation).translation
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataManager.instance.managedObjectContext.delete((word?.translations?.allObjects[indexPath.row])! as! Translation)
            CoreDataManager.instance.saveContext()
            tableView.reloadData()
        }
    }
}
