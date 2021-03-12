//
//  ViewController.swift
//  CoreDataCRUD
//
//  Created by Sahan Ravindu on 7/19/20.
//  Copyright © 2020 Sahan Ravindu. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    //MARK:- Variables
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var userList:[User] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupUI()
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    @IBAction func didTapAdd(_ sender: Any) {
        
         self.alertField(action: .add)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.userList[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let contextItem = UIContextualAction(style: .destructive, title: "DELETE") {  (contextualAction, view, boolValue) in
            //Code I want to do here
            self.alertField(action: .delete, index: indexPath.row)
            
        }
        
        let contextItem1 = UIContextualAction(style: .normal, title: "EDIT") {  (contextualAction, view, boolValue) in
            //Code I want to do here
            self.alertField(action: .edit, index: indexPath.row)
            //self.deleteRow(index: indexPath.row)
            
        }
        
        contextItem1.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        contextItem1.image = #imageLiteral(resourceName: "ic_settings_edit_pet_bio")
        
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem, contextItem1])
        
        
        return swipeActions
    }
    
    
}

//MARK:- Coredata Operations
extension ViewController {
    
    //MARK:- Save data
    func saveData() {
        do {
            
            try context.save()
            
        } catch {
            print("Cannot Save Data \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //MARK:- ADD Data
    func addData(name: String) {
        let newUser = User(context: self.context)
        newUser.name = name
        self.userList.append(newUser)
        self.saveData()
    }
    
    //MARK:- Load Data
    func loadData() {
        let request: NSFetchRequest<User> =  User.fetchRequest()
        
        do {
            
            userList = try context.fetch(request)
            
        } catch {
            print("Cannot fetch Data \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //MARK:- Edit Data
    func editData(name: String, index: Int?) {
        if let _index = index {
            self.userList[_index].setValue(name, forKey: "name")
            self.saveData()
            
        }
    }
    
    //MARK:- Delete Data
    func deleteData(name: String, index: Int?) {
        if let _index = index {
            self.context.delete(self.userList[_index])
            self.userList.remove(at: _index)
            self.saveData()
        }
    }
    
    
    
}


//MARK:- Operations
extension ViewController {
    
    //******** Add / Edit / Delete alert
    func alertField(action: actions = .add, index: Int? = nil) {
        
        var userNameText: UITextField = UITextField()
        
        //Alert Controllers
        var alert = UIAlertController()
        var title: String = ""
        var message: String = ""
        
        switch action {
        case .add:
            title = "Add New Item"
            message = "Add New User"
            
            alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add User", style: .default) { (action) in
                
                self.addData(name: userNameText.text ?? "")
            }
            
            alert.addAction(action)
            
            alert.addTextField { (textField) in
                textField.placeholder = "Add new user"
                
                userNameText = textField
            }
            
        case .edit:
            title = "Edit Item"
            message = "Update User"
            
            alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Edit User", style: .default) { (action) in
                
                self.editData(name: userNameText.text ?? "", index: index)
                
            }
            
            alert.addAction(action)
            
            alert.addTextField { (textField) in
                textField.placeholder =  "Updste User"
                if let _index = index {
                    textField.text = self.userList[_index].name
                }
                userNameText = textField
            }
            
        case .delete:
            title = "Delete Item"
            message = "Are ypu sure you wants to delete?"
            
            alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let actionDelete = UIAlertAction(title: "Delete Item", style: .destructive) { (action) in
                
                self.deleteData(name: userNameText.text ?? "", index: index)
                
            }
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            }
            
            alert.addAction(actionDelete)
            alert.addAction(actionCancel)
        }
        
        present(alert, animated: true, completion: nil)
        
        
    }

}

enum actions {
    case add
    case edit
    case delete
}
