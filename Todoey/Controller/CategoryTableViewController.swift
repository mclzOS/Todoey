//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Mircea Zahacinschi on 28.11.18.
//  Copyright © 2018 Mircea Zahacinschi. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()

    }
    
    
    //Mark: - Tableview Datasources
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCategory", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].categories
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //Mark: - Data Manipulation Methods
    
    func saveCategory (){
        
        do {
            try context.save()
            
        }catch {
            print ("This is the \(error)")
        }
        tableView.reloadData()
    }
        
        
    func loadCategory(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
            
        }catch {
            print ("This is the \(error)")
        }
            tableView.reloadData()
        }
    
    
    //Mark: - Add new Categories
    
    @IBAction func addNewCategories(_ sender: UIBarButtonItem) {
        
        var newCategoryString = UITextField()
        
        let alert = UIAlertController(title: "Add new categories", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Create category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            
            newCategory.categories = newCategoryString.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
            
        }
        
        alert.addTextField { (actionTextField) in
            actionTextField.placeholder = "Create new category"
            newCategoryString = actionTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
            
        
        
        
}
}