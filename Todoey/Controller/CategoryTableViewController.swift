//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Mircea Zahacinschi on 28.11.18.
//  Copyright © 2018 Mircea Zahacinschi. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    var categoryArray: Results<Category>?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()

    }
    
    
// Mark: - Tableview Datasources
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCategory", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].categoryName ?? "No categories added yet"
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
// Mark: - Data Manipulation Methods
    
    func saveCategory (category: Category){
        
        do {
            try realm.write{
                realm.add(category)
            }
            
        }catch {
            print ("This is the \(error)")
        }
        tableView.reloadData()
    }
        
        
    func loadCategory() {
        
        categoryArray = realm.objects(Category.self)
        
            tableView.reloadData()
        }
    
     
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeAction = UIContextualAction(style: .destructive, title: "done") { (UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
            
            if self.categoryArray != nil {
                do {
                    try self.realm.write {
                        self.realm.delete(self.categoryArray![indexPath.row])
                    } }
                catch {
                        print (error)
                    }
            }else {
                return
            }
            
            tableView.reloadData()
            
        }
        return UISwipeActionsConfiguration(actions: [swipeAction])
    }
    
// Mark: - Add new Categories
    
    @IBAction func addNewCategories(_ sender: UIBarButtonItem) {
        
        var newCategoryString = UITextField()
        
        let alert = UIAlertController(title: "Add new categories", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Create category", style: .default) { (action) in
            
            
            let newCategory = Category()
            
            newCategory.categoryName = newCategoryString.text!
            
            self.saveCategory(category: newCategory)
            
        }
        
        alert.addTextField { (actionTextField) in
            actionTextField.placeholder = "Create new category"
            newCategoryString = actionTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
}
    
    
// Mark: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    
    
    
    
    
}
