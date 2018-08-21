//
//  ViewController.swift
//  TodoeyAppP2
//
//  Created by Mirshad Ozuturk on 8/16/18.
//  Copyright © 2018 Mirshad Ozuturk. All rights reserved.
//

import UIKit
import RealmSwift

class ItemsListViewController: UITableViewController {
    
    let realm = try! Realm()
    var todoItems: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
//        loadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.name
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
                
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
//                    realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("Error saving to Realm")
            }
        }
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var myTextField = UITextField()
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            print("Alert Add Button Pressed")

            if let anotherCategory = self.selectedCategory {
                print("Kotakpas")
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.name = myTextField.text!
                        newItem.done = false
                        anotherCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving to Realm!")
                }
                
            }
            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            myTextField = alertTextField
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)

        
    }
    
    func loadData() {
        print("Loading data")
        todoItems = selectedCategory?.items.sorted(byKeyPath: "name", ascending: true)
        
        tableView.reloadData()
    }
}

extension ItemsListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            tableView.reloadData()
            
        }
        
    }
    
}




