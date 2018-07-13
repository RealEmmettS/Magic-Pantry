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
    var items = [GroceryItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference().child("list-items")
        startObservingDB()
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
    
    
    
    
    
//    func startObservingDB () {
//        dbRef.observe(.value, with: { (snapshot:DataSnapshot) in
//            var newitems = [GroceryItem]()
//
//            for item in snapshot.children {
//                let itemObject = GroceryItem(snapshot: item as! DataSnapshot)
//                newitems.append(itemObject)
//            }
//
//            self.items = newitems
//            self.tableView.reloadData()
//
//        }) { (error:Error) in
//            print("There has been an error. Sorry for the trouble!")
//            }
//    }
    
    
    
    
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addItem(_ sender: Any) {
        let newItemAlert = UIAlertController(title: "New Item", message: "Enter Item Name", preferredStyle: .alert)
        newItemAlert.addTextField(configurationHandler:) { (textField:UITextField) in textField.placeholder = "Item Name"
        }
        newItemAlert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { (action:UIAlertAction) in
            if let itemContent = newItemAlert.textFields?.first?.text{
                let product = GroceryItem(content: itemContent, addedByUser: "Emmett S.")
                
                let itemRef = self.dbRef.child(itemContent.lowercased())
                
                itemRef.setValue(product.toAnyObject())
            }
            
        }))
        self.present(newItemAlert, animated: true, completion: nil)
    }
    
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return items.count
    }

    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)

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
