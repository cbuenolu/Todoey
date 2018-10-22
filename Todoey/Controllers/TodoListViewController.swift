//
//  ViewController.swift
//  Todoey
//
//  Created by Carlos Miguel Bueno Lujan on 14/10/18.
//  Copyright © 2018 Carlos Miguel Bueno Lujan. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit


class TodoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()

    var todoItems : Results<Item>?
    var selectedCategory : Category? {
        didSet{
            
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.selected ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items yet"
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let item = todoItems? [indexPath.row] {
            do {
                try realm.write {
                    item.selected = !item.selected
                }
            } catch {
                print ("Error saving done status \(error)")
            }
            
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.updateModel(at: indexPath)
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete_icon")
        
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the add Item button on our UIAlert
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        let item = Item()
                        item.title = textField.text!
                        item.dateCreated = Date()
                        currentCategory.items.append(item)
                    }
                } catch  {
                    print ("Error saving items. \(error)")
                }
            }
            
            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField

        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    

    }
    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    
    }
    
    // MARK - Delete from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemToDelete = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemToDelete)
                }
            } catch  {
                print ("Error saving items. \(error)")
            }
        }
        
    }
     
}

// MARK - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@" , searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)

        self.tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
