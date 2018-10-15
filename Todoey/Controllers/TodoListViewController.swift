//
//  ViewController.swift
//  Todoey
//
//  Created by Carlos Miguel Bueno Lujan on 14/10/18.
//  Copyright © 2018 Carlos Miguel Bueno Lujan. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let defaults = UserDefaults.standard
    var itemArray = [Item]()
    override func viewDidLoad() {
        super.viewDidLoad()
        populateItemArray()
    }
    
    func populateItemArray() {
        let item = Item()
        item.tittle = "Find Mike"
        itemArray.append(item)
        let itemTwo = Item()
        itemTwo.tittle = "Buy Eggos"
        itemArray.append(itemTwo)
        let itemThree = Item()
        itemThree.tittle = "Destory Demogorgon"
        itemArray.append(itemThree)
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
    }
    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoITemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.tittle
        cell.accessoryType = item.selected ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        print ("Element: \(itemArray[indexPath.row].tittle)")
        itemArray[indexPath.row].selected = !itemArray[indexPath.row].selected
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the add Item button on our UIAlert
            print ("Element pressed")
            print (textField.text!)
            let item = Item()
            item.tittle = textField.text!
            self.itemArray.append(item)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField

        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    

}

