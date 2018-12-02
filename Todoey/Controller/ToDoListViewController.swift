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
    
    var itemArray: Results<Item>?
    
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
        

        }
    
//Mark - Tableview Datasource Methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray?[indexPath.row].title ?? "No tasks created yet"
        
        cell.accessoryType = itemArray?[indexPath.row].done == true ? .checkmark : .none ?? .none
        
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    
    //Mark - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray?[indexPath.row].done = !itemArray![indexPath.row].done
        
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        }
    
    
    //Mark - Add new Items to database
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add new ToDo", style: .default) { (action) in
            
            let newItem = Item()
            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
            newItem.title = textField.text!
            
            do {
                try self.realm.write {
                    self.realm.add(newItem)
                }
            }
                catch {
                    print (error)
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
        
        itemArray = realm.objects(Item.self)
        
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.categories MATCHES[cd] %@", selectedCategory!.categories!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate,categoryPredicate])
//        }else {
//            request.predicate = categoryPredicate
//        }
//
//
//            do {
//                itemArray = try context.fetch(request)
//            }catch {
//                print (error)
//            }
        tableView.reloadData()
        }

}

//extension ToDoListViewController: UISearchBarDelegate{
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadData(with: request)
//
//    }
//
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text!.count == 0 {
//            loadData()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//        }
//    }
//
//}


