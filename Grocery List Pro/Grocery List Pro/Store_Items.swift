//
//  Store_Items.swift
//  Grocery List Pro
//
//  Created by Emmett Shaughnessy on 7/13/18.
//  Copyright © 2018 Emmett Shaughnessy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class Store_Items: UITableViewController {
    
    var items = [GroceryItem]()
    var dbRef:DatabaseReference!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        dbRef = Database.database().reference().child(stringMyIndex!)
        startObservingDB()
        
    }
    
    
    
    
    @IBAction func addItem(_ sender: Any) {
        let newItemAlert = UIAlertController(title: "New Item", message: "Enter Item Name", preferredStyle: .alert)
        newItemAlert.addTextField(configurationHandler:) { (textField:UITextField) in textField.placeholder = "Item Name"
        }
        newItemAlert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { (action:UIAlertAction) in
            if let ItemContent = newItemAlert.textFields?.first?.text{
                
                
                //Setting cell content
                let item = GroceryItem(content: ItemContent, addedByUser: currentUsersEmail.currentUsersEmail)
                
                let itemRef = self.dbRef.child(ItemContent.lowercased())
                
                itemRef.setValue(item.toAnyObject())
            }
            
        }))
        self.present(newItemAlert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    func startObservingDB() {
        
        dbRef.observe(.value, with: { (snapshot:DataSnapshot) in
            var newItems = [GroceryItem]()
            
            for Item in snapshot.children {
                let itemObject = GroceryItem(snapshot: Item as! DataSnapshot)
                newItems.append(itemObject)
            }
            
            self.items = newItems
            self.tableView.reloadData()
            
            
        }) { (error:Error) in
            print("There has been an error. Sorry for the trouble!")
        }
        
    }
    
    
    
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let Item = items[indexPath.row]
        
        cell.textLabel?.text = Item.content
        cell.detailTextLabel?.text = Item.addedByUser
        
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            let Item = items[indexPath.row]
            
            Item.itemRef?.removeValue()
        }
    }
    
    

    

}
