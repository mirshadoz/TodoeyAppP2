//
//  ViewController.swift
//  TodoeyAppP2
//
//  Created by Mirshad Ozuturk on 8/16/18.
//  Copyright © 2018 Mirshad Ozuturk. All rights reserved.
//

import UIKit
import CoreData

class ItemsListViewController: UITableViewController {
    
    var itemsArray = [Item]()
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
        loadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        
        print(itemsArray[indexPath.row].done)
        
        cell.textLabel?.text = itemsArray[indexPath.row].name
        cell.accessoryType = itemsArray[indexPath.row].done ? .checkmark : .none
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
           tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done
        
        saveData()
        
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var myTextField = UITextField()
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            print("Alert Add Button Pressed")
            
            let newItem = Item(context: self.myContext)
            newItem.name = myTextField.text!
            newItem.done = false
            self.itemsArray.append(newItem)
            
            self.tableView.reloadData()
            
            self.saveData()
        }
        
        alert.addTextField { (alertTextField) in
            myTextField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)

        
    }
    
    func saveData() {
        do {
            try myContext.save()
        } catch {
            print("Error saving to context \(error)")
        }
    }
    
    func loadData(fetchRequest: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        if let anotherPredicate = predicate {
            fetchRequest.predicate = anotherPredicate
        }
        
        do {
            itemsArray = try myContext.fetch(fetchRequest)
        } catch {
            print("Error loading from Context \(error)")
        }
        
        tableView.reloadData()
    }
}

extension ItemsListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        
        let searchItem = searchBar.text!
        
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchItem)
        
        loadData(predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            loadData()
            
            tableView.reloadData()
            
        }
        
    }
    
}




