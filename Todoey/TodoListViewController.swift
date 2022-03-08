//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController{
    
    var itemArray: Array<Item> = []
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadDataFromFile()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance

    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCell, for: indexPath)
        
//        let cell = UITableViewCell(style: .default, reuseIdentifier: K.reusableCell)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        if itemArray[indexPath.row].done {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    // Is working when cell is sellected (tapped)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        if itemArray[indexPath.row].done {
            itemArray[indexPath.row].done = false
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            itemArray[indexPath.row].done = true
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        self.saveDataToFile()
        tableView.deselectRow(at: indexPath, animated: true) // Automatyczne odznaczanie komórki
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Add Item", style: .default) { action in
            // what will happend once the user
            
            if let text = textField.text {
                if text != "" {
                    // Add item to the itemsArray
                    let newItem = Item(title: text)
                    self.itemArray.append(newItem)
                    
                    // Save data to my own .plist file
                    self.saveDataToFile()
                    
                    // Reload tableView data
                    self.tableView.reloadData()
                }
            }
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Save data to file
    
    func saveDataToFile() {
        let encoder = PropertyListEncoder()
        do {
            if let safeDataFilePath = self.dataFilePath {
                let data = try encoder.encode(self.itemArray)
                try data.write(to: safeDataFilePath)
            }
        } catch {
            print(error)
        }
    }
    
    func loadDataFromFile() {
        if let safeDataFilePath = self.dataFilePath {
            do {
                if let data = try? Data(contentsOf: safeDataFilePath) {
                    let decoder = PropertyListDecoder()
                    self.itemArray = try decoder.decode(Array<Item>.self, from: data)
                }
            } catch {
                print(error)
            }
        }
    }
}
