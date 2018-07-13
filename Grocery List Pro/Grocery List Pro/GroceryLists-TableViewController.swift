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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Auth.auth().addStateDidChangeListener { (auth:Auth?, user) in
            if let user = user {
                print("Welcome \(user.email)!")
                self.startObservingDB()
            } else {
                print("You need to sign-up or login first!")
            }
        }
        
        
    }
    
    
    
    
    
    @IBAction func logInAndSignUp(_ sender: Any) {
        
        let userAlert = UIAlertController(title: "Login/Sign-Up", message: "Enter Email and Passowrd", preferredStyle: .alert)
        userAlert.addTextField(configurationHandler: { (textField:UITextField) in
            textField.placeholder = "Email"
            })
        userAlert.addTextField(configurationHandler: { (textField:UITextField) in
            textField.isSecureTextEntry = true
            textField.placeholder = "Password"
        })
        
        
        
        
        
        //Login
        userAlert.addAction(UIAlertAction(title: "Login", style: .default, handler: { (action:UIAlertAction) in
            let emailTextField = userAlert.textFields!.first!
            let passwordTextField = userAlert.textFields!.last!
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if Error.self != nil {
                    print("A Login Error has Occured")
                }
            }
        }))
        
        
        //Sign-Up
        userAlert.addAction(UIAlertAction(title: "Sign-Up", style: .default, handler: { (action:UIAlertAction) in
            let emailTextField = userAlert.textFields!.first!
            let passwordTextField = userAlert.textFields!.last!
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
                if Error.self != nil {
                    print("A Login Error has Occured")
                }
            }
        }))
        
        self.present(userAlert, animated: true, completion: nil)
        
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
                let product = GroceryItem(content: itemContent, addedByUser: "Anonymous")
                
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
