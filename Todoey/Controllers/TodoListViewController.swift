//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Abhas Kumar on 31/05/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLongPressGesture()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - tabel View data Resouce
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
            //cell.textLabel?.text = item.title
            //cell.accessoryType = item.done ? .checkmark: .none
            let attributes: [NSAttributedString.Key: Any] =
                [NSAttributedString.Key.strikethroughStyle: 1]
            cell.textLabel?.attributedText = item.done ? NSAttributedString(string: item.title, attributes: attributes): NSAttributedString(string: item.title)
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            if let item = todoItems?[indexPath.row] {
                do {
                    try realm.write{
                        realm.delete(item)
                    }
                } catch {print(error)}
            }
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {

        let closeAction = UIContextualAction(style: .normal, title:  "Strike item", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("CloseAction ...")
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
            if let item = self.todoItems?[indexPath.row] {
               //cell.textLabel?.text = item.title
               //cell.accessoryType = item.done ? .checkmark: .none
               let attributes: [NSAttributedString.Key: Any] =
                   [NSAttributedString.Key.strikethroughStyle: 1]
                
                do {
                    try self.realm.write{
                        item.done = !item.done
                    }
                } catch {print(error)}
               cell.textLabel?.attributedText = item.done ? NSAttributedString(string: item.title, attributes: attributes): NSAttributedString(string: item.title)
           }
            success(true)
        })
        closeAction.backgroundColor = .blue
        tableView.reloadData()
        return UISwipeActionsConfiguration(actions: [closeAction])

    }
    
    //MARK: - Tabel View delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write{
                    item.done = !item.done
                }
            } catch {
                print(error)
            }
        }
        tableView.reloadData()
    }
    
    //MARK: -Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What happens when user will click one user taps on ADD ITEM on UIAlert
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write{
                        let newItem = Item()
                        if textField.text!.isEmpty{
                            return
                        } else {
                            newItem.title = textField.text!
                            currentCategory.items.append(newItem)
                        }
                    }
                } catch {print(error)}
                
            }
            self.tableView.reloadData()}
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter New Todo Here"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manipulation Methods
    
    func saveItems(item: Item) {
        do {
            try realm.write{
                realm.add(item)
            }
        } catch{
            print(error)
        }
        
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                var textField = UITextField()
                let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Edit Item", style: .default) { (action) in
                    //What happens when user will click one user taps on ADD ITEM on UIAlert
                        do{
                            try self.realm.write{
                                if let newItem = self.todoItems?[indexPath.row] {
                                    if textField.text! == ""{
                                        return
                                    } else {
                                        newItem.title = textField.text!
                                    }
                                }
                            }
                        } catch {print(error)}
                    self.tableView.reloadData()}
                
                alert.addTextField { (alertTextField) in
                    alertTextField.text = self.todoItems?[indexPath.row].title
                    alertTextField.placeholder = "Enter New Todo Here"
                    textField = alertTextField
                }
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        }
    }
}

//MARK:- Extension for UISearchBarDelegate(Search bar Methods)

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
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
