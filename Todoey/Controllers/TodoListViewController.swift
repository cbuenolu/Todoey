//
//  ViewController.swift
//  Todoey
//
//  Created by Carlos Miguel Bueno Lujan on 14/10/18.
//  Copyright © 2018 Carlos Miguel Bueno Lujan. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoITemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.selected ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        print ("Element: \(itemArray[indexPath.row].title)")
        itemArray[indexPath.row].selected = !itemArray[indexPath.row].selected
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the add Item button on our UIAlert
            print ("Element pressed")
            print (textField.text!)
            let item = Item(context: self.context)
            item.title = textField.text!
            item.selected = false
            item.parentCategory = self.selectedCategory
            self.itemArray.append(item)
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField

        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    func saveItems() {
        do {
            try context.save()
        } catch  {
            print ("Error save items. \(error)")
        }
        self.tableView.reloadData()

    }
    
    func loadItems(request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }

        do {
            try itemArray = context.fetch(request)
        } catch  {
            print ("Error fetching items. \(error)")
        }
        self.tableView.reloadData()
    
    }
}

// MARK - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[dc] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(request: request, predicate: predicate)

        self.tableView.reloadData()

        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
        }
    }
    
}
