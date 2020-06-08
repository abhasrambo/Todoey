//
//  CategoryVoiewController.swift
//  Todoey
//
//  Created by Abhas Kumar on 5/31/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var category: Results<Category>?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

    }

    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category ToDo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //What happens when user will click one user taps on ADD ITEM on UIAlert
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
            
    }
            alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter New Category Here"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Tableview datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = category?[indexPath.row].name ?? "No Categoriesa added yet"
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            context.delete(category[indexPath.row]  as NSManagedObject)
//            category.remove(at: indexPath.row)
//            saveCategory()
//        }
//}
    
    //MARK:- Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = category?[indexPath.row]
        }
    }
    //MARK:- Tabelview Manupulation Methods
    
    func save(category: Category) {
                       do {
                        try realm.write{
                            realm.add(category)
                        }
                       } catch{
                           print(error)
                       }
                       
                       
            self.tableView.reloadData()
        }
        
    func loadCategories(){
        category = realm.objects(Category.self)
        tableView.reloadData()
        
        }
   }
