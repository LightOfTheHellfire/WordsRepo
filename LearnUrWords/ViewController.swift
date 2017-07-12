//
//  ViewController.swift
//  LearnUrWords
//
//  Created by Admin on 13.06.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UISearchResultsUpdating {
    
//MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    var searchController: UISearchController!
    var searchResult: [Word] = []
    let textCellIdentifier = "TextCell"
    let check = CheckViewController()
    var fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "Word", keyForSort: "word", isAscending: true)
    var tableData: [Word] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpObjects()
        loadData()
    }

    @IBAction func addWord(_ sender: UIBarButtonItem) {
        LocalNotification.instance.add()
        //performSegue(withIdentifier: "ShowWordSegue", sender: nil)
    }
    
//MARK: TableView didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let word = (searchController.isActive) ? searchResult[indexPath.row] : tableData[indexPath.row]
        performSegue(withIdentifier: "ShowWordSegue", sender: word)
    }
    
//MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(searchText: searchText)
            tableView.reloadData()
        }
    }
    
    func filterContent(searchText: String) {
        searchResult = tableData.filter({(word: Word) -> Bool in
            let match = word.word?.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return match != nil
        })
    }
    
//MARK: Setting up objects
    func setUpObjects() {
        self.view.backgroundColor = UIColor.gray
        tableView.backgroundColor = UIColor.gray
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Type here for searching words.."
        fetchedResultsController.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = searchController.searchBar
    }
    
//MARK: Loading Data
    func loadData() {
        do {
            try fetchedResultsController.performFetch()
            tableData = fetchedResultsController.fetchedObjects as! [Word]
        } catch {
            print(error)
        }
    }
}

//MARK: Navigation
extension ViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "ShowWordSegue"
        {
            let nav = segue.destination as! UINavigationController
            let destination = nav.topViewController as! EditViewController
            destination.word = sender as? Word
        } else if segue.identifier == "CheckSegue" {
            let destination = segue.destination as! CheckViewController
            destination.words = tableData
        }
    }
}

//MARK: TableView
extension ViewController: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResult.count
        } else {
            return tableData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)

        let word = (searchController.isActive) ? searchResult[indexPath.row] : tableData[indexPath.row]
        cell.textLabel?.text = word.word
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false

        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let managedObject = fetchedResultsController.object(at: indexPath) 
            CoreDataManager.instance.managedObjectContext.delete(managedObject)
            CoreDataManager.instance.saveContext()
            tableData = fetchedResultsController.fetchedObjects as! [Word]
        }
    }
}

// MARK: - Fetched Results Controller Delegate

extension ViewController: NSFetchedResultsControllerDelegate {
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            tableView.reloadData()
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        tableData = fetchedResultsController.fetchedObjects as! [Word]
    }
    
}
