//
//  CategoryTableViewController.swift
//  TodoeyAppP2
//
//  Created by Mirshad Oz on 8/17/18.
//  Copyright © 2018 Mirshad Ozuturk. All rights reserved.
//

// STOP AT Section: 19, Lecture: 270

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoriesArray: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        
        
        loadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("numberOfRowsInSection")
        
        return categoriesArray?.count ?? 1
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("cellForRowAt")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! SwipeTableViewCell

        cell.textLabel?.text = categoriesArray?[indexPath.row].name ?? "No Categories add yet!"
        
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Category is selected!")
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemsListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
           destinationVC.selectedCategory = categoriesArray?[indexPath.row]
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var myTextField = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            print("Added New")
            let newCategory = Category()
            newCategory.name = myTextField.text!
            
            self.saveData(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            myTextField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveData(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving to Category context")
        }
        
        tableView.reloadData()

        
    }
    
    func loadData() {
        categoriesArray = realm.objects(Category.self) // Function Returns all objects of given type.
        
//        let length = categoriesArray?.count as! Int
//        
//        if length == 0 {
//            print("Categories Array is Empty!")
//            categoriesArray = nil
//            tableView.reloadData()
//        }
        
    }
    

}

extension CategoryTableViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            print("Category Deleted!")
            
            if let anotherCategory = self.categoriesArray?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(anotherCategory)
                    }
                } catch {
                    print("Error deleting caategory after swipe")
                }
                
                

            }
            
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        
        return options
        
    }
    
    
}

