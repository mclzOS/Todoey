//
//  ViewController.swift
//  Todoey
//
//  Created by Mircea Zahacinschi on 18.11.18.
//  Copyright © 2018 Mircea Zahacinschi. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController{
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let newItem = Item()
        newItem.itemName = "Find Mike"
        itemArray.append(newItem)
        
      if let items = defaults.array(forKey: "toDoListSaved") as? [Item] {
            itemArray = items
        
        }
    }
    //Mark - Tableview Datasource Methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].itemName
        
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
        
        
//        if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        }
//
//        else {
//            cell.accessoryType = .none
//        }
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    //Mark - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }
//
//        else {
//            itemArray[indexPath.row].done = false
//
//        }
//
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        }
    
    
    //Mark - Add new Items to database
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add new ToDo", style: .default) { (action) in
            
            let newItem = Item()
            newItem.itemName = textField.text!
            
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "toDoListSaved")

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

