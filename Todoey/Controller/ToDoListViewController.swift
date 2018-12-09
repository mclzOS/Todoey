//
//  ViewController.swift
//  Todoey
//
//  Created by Mircea Zahacinschi on 18.11.18.
//  Copyright © 2018 Mircea Zahacinschi. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    
    
    var tasks: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
        
    }
    
    
    let dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print (Realm.Configuration.defaultConfiguration.fileURL!)
        }
    
//Mark - Tableview Datasource Methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        
        if let item = tasks?[indexPath.row] {
            cell.textLabel?.text = tasks?[indexPath.row].title
            
            cell.accessoryType = tasks?[indexPath.row].done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No tasks added"
            
        }
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 1
    }
    
    
// Mark - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = tasks?[indexPath.row] {
            do {
            try realm.write {
                item.done = !item.done
            }
            } catch {
                print ("Error under selectRow \(error)")
            }
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    //Mark - Add new Items to database
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add new ToDo", style: .default) { (action) in
            
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }
                catch {
                    print (error)
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
    
    

    
    func loadData(){
        
        tasks = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        }

}

extension ToDoListViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        tasks = tasks?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()



    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            loadData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}
}


