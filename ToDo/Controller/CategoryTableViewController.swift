//
//  CategoryTableViewController.swift
//  ToDo
//
//  Created by Phaniraj UV on 23/02/18.
//  Copyright © 2018 Phaniraj UV. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
     var categories = [Category]()
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
         return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
       
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItem", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.saveItems()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            let newItem = Category(context: self.context)
            newItem.name = textField.text!
           
            self.categories.append(newItem)
            self.saveItems()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter the item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated : true , completion: nil)
    }
        
        func saveItems() {
            
            do {
                try context.save()
            }
            catch {
                print("Error:\(error)")
                
            }
            
            
        }
        
        func loadItems(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
            
            
            do {
                categories = try context.fetch(request)
            }
            catch {
                print("error \(error)")
            }
            tableView.reloadData()
            
        }
        

}
