//
//  CategoryTableViewController.swift
//  TodoeyAppP2
//
//  Created by Mirshad Oz on 8/17/18.
//  Copyright © 2018 Mirshad Ozuturk. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoriesArray: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("numberOfRowsInSection")
        
        return categoriesArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("cellForRowAt")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

        cell.textLabel?.text = categoriesArray?[indexPath.row].name ?? "No Categories add yet!"
        
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



