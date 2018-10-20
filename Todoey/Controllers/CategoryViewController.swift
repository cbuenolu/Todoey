//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Carlos Miguel Bueno Lujan on 18/10/18.
//  Copyright © 2018 Carlos Miguel Bueno Lujan. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    // MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    // this function is call before performSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    // MARK - Data Manipulate Methods
    
    func saveCategories() {
        do {
            try context.save()
        } catch  {
            print ("Error save items. \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    func loadCategories() {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest (request: request)
        
    }
    
    func fetchRequest (request: NSFetchRequest<Category>) {
        do {
            try categoryArray = context.fetch(request)
        } catch  {
            print ("Error fetching items. \(error)")
        }
        self.tableView.reloadData()
    }
    
    // MARK - Add Category
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            // what will happen once the user clicks the add Item button on our UIAlert
            print (textField.text!)
            let category = Category(context: self.context)
            category.name = textField.text!
            self.categoryArray.append(category)
            self.saveCategories()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
}
