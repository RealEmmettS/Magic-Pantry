//
//  GroceryLists-TableViewController.swift
//  
//
//  Created by Emmett Shaughnessy on 7/12/18.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class GroceryLists_TableViewController: UITableViewController {
    
    var dbRef:DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference().child("list-items")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addItem(_ sender: Any) {
        let newItemAlert = UIAlertController(title: "New Item", message: "Enter Item Name", preferredStyle: .alert)
        newItemAlert.addTextField(configurationHandler:) { (textField:UITextField) in textField.placeholder = "Item Name"
        }
        newItemAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action:UIAlertAction) in
            if let itemContent = newItemAlert.textFields?.first?.text{
                let item = GroceryItem(content: itemContent, addedByUser: "Emmett S.")
                
                let itemRef = self.dbRef.child(itemContent.lowercased())
                
                itemRef.setValue(item.toAnyObject())
            }
            
        }))
        self.present(newItemAlert, animated: true, completion: nil)
    }
    
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...

        return cell
    }
    
    
    
    
}
