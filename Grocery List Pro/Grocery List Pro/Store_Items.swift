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

//Defining Global Variables
var ItemdbRef: DatabaseReference!
var dbRefI:DatabaseReference!


class Store_Items: UITableViewController {
    
    var items = [GroceryItem]()
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dbRefI = Database.database().reference().child("\(stringStoreName!)-\(validationID)")
        startObservingDB()
        ItemdbRef = dbRefI
    }
    
    func SpecialCharacterError() {
        //Set up alert and its contents
        let alert = UIAlertController(title: "Error", message: "Please do not use periods, slashes, or anything of the like in an item name", preferredStyle: UIAlertControllerStyle.alert)
        //Set up alert button
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        //Present Alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    //Start of AddItem
    @IBAction func addItem(_ sender: Any) {
        let newItemAlert = UIAlertController(title: "New Item", message: "Enter Item Name", preferredStyle: .alert)
        newItemAlert.addTextField(configurationHandler:) {
            (textField:UITextField) in textField.placeholder = "Item Name"
            textField.autocorrectionType = .yes
        }
        newItemAlert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { (action:UIAlertAction) in
            //Checks if field is empty
            var textUserInput = newItemAlert.textFields?.first?.text
            if newItemAlert.textFields?.first?.text == nil || newItemAlert.textFields?.first?.text == "" || newItemAlert.textFields?.first?.text == " "{
                textUserInput = "Unavaliable"
            }
            //checks is text conatins special characters
            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 &%@!*")
            //Scans textUserInput for anything "out of the ordinary"
            if textUserInput!.rangeOfCharacter(from: characterset.inverted) != nil {
                self.SpecialCharacterError()
            } else {
                //Starts setting cell content
                if let ItemContent = textUserInput{
                    //Setting cell content
                    let item = GroceryItem(content: ItemContent, addedByUser: (Auth.auth().currentUser?.uid)!)
                    
                    let itemRef = dbRefI.child(ItemContent.lowercased())
                    
                    itemRef.setValue(item.toAnyObject())
                }

            }
            
        }))
        self.present(newItemAlert, animated: true, completion: nil)
    }
    
    //End of AddItem
    
    
    
    
    
    func startObservingDB() {
        
        dbRefI.observe(.value, with: { (snapshot:DataSnapshot) in
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
        //Below, replace "" with currentUsersEmail.currentUsersEmail to make it display the users email who added it
        cell.detailTextLabel?.text = ""
        
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            let Item = items[indexPath.row]
            
            Item.itemRef?.removeValue()
        }
    }
    
    

    

}
