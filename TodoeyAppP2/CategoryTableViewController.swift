//
//  CategoryTableViewController.swift
//  TodoeyAppP2
//
//  Created by Mirshad Oz on 8/17/18.
//  Copyright © 2018 Mirshad Ozuturk. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoriesArray = [Category]()
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = categoriesArray[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Category is selected!")
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemsListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
           destinationVC.selectedCategory = categoriesArray[indexPath.row]
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var myTextField = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            print("Added New")
            let newCategory = Category(context: self.myContext)
            newCategory.name = myTextField.text!
            
            self.categoriesArray.append(newCategory)
            
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
            print("Error saving to Category context")
        }
        
    }
    
    func loadData() {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoriesArray = try myContext.fetch(fetchRequest)
        } catch {
            print("Error loading from Category Context")
        }
        
    }
    

}



