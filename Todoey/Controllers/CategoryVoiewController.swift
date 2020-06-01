//
//  CategoryVoiewController.swift
//  Todoey
//
//  Created by Abhas Kumar on 5/31/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    let category = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
    
//    //MARK:- Tableview datasource methods
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return categoryArray.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
//        cell.textLabel?.text = categoryArray[indexPath.row].
//        return cell
//    }
    
    //MARK:- Tableview Delegate Methods
    
    
    //MARK:- Tabelview Manupulation Methods
    
}
