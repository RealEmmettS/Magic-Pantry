//
//  GroceryLists-TableViewController.swift
//  
//
//  Created by Emmett Shaughnessy on 7/12/18.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


var myIndex = 0
var stores = [GroceryStore]()
var currentUsersEmail = extraUserInfo(currentUsersEmail: "")
var stringMyIndex : String?

class GroceryLists_TableViewController: UITableViewController {
    
    var dbRef:DatabaseReference!


    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference().child("list-stores")
        startObservingDB()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Auth.auth().addStateDidChangeListener { (auth:Auth?, user) in
            if let user = user {
                print("Welcome \(user.email)!")
                currentUsersEmail.currentUsersEmail = user.email
                self.startObservingDB()
            } else {
                print("You need to sign-up or login first!")
            }
        }
        
        
    }
    
    
    
    
    
    
    
    
    @IBAction func logInAndSignUp(_ sender: Any) {
        
        let userAlert = UIAlertController(title: "Login/Sign-Up", message: "Enter Email and Passowrd\n(MUST be at least 6 characters)", preferredStyle: .alert)
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
            
            self.signInNotification()
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if Error.self != nil {
                    print("A Login Error has Occured")
                } else {
                    print("Login went well. Clear to proceed.")
                }
            }
            
            currentUsersEmail.currentUsersEmail = emailTextField.text!
            
            
            
        }))
        
        
        //Sign-Up
        userAlert.addAction(UIAlertAction(title: "Sign-Up", style: .default, handler: { (action:UIAlertAction) in
            let emailTextField = userAlert.textFields!.first!
            let passwordTextField = userAlert.textFields!.last!
            
            self.signInNotification()
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
                
                
                if Error.self != nil {
                    print("A Login Error has Occured")
                } else {
                    print("Login went well. Clear to proceed.")
                }
                
                
            }
            
            
            currentUsersEmail.currentUsersEmail = emailTextField.text!
            
            
            
            
        }))
        
        self.present(userAlert, animated: true, completion: nil)
        
    }
    
    
    
    //Sign Out
    @IBAction func SignOut(_ sender: Any) {
        
        currentUsersEmail.currentUsersEmail = ""
        signOutNotification()
        
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
    }
    
    
    func signOutNotification() {
        let ErrorAlert = UIAlertController(title: "Successful", message: "Signed Out Successfully!", preferredStyle: .alert)
        
        ErrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(ErrorAlert, animated: true, completion: nil)
    }
    
    func signInNotification() {
        let ErrorAlert = UIAlertController(title: "Successful", message: "Logged In Successfully!", preferredStyle: .alert)
        
        ErrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(ErrorAlert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    func startObservingDB() {

        dbRef.observe(.value, with: { (snapshot:DataSnapshot) in
            var newItems = [GroceryStore]()

            for Item in snapshot.children {
                let itemObject = GroceryStore(snapshot: Item as! DataSnapshot)
                newItems.append(itemObject)
            }

            stores = newItems
            self.tableView.reloadData()


        }) { (error:Error) in
            print("There has been an error. Sorry for the trouble!")
        }

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

        
    
    
    @IBAction func addItem(_ sender: Any) {
        let newItemAlert = UIAlertController(title: "New Store", message: "Enter Store Name", preferredStyle: .alert)
        newItemAlert.addTextField(configurationHandler:) { (textField:UITextField) in textField.placeholder = "Store Name"
        }
        newItemAlert.addAction(UIAlertAction(title: "Add Store", style: .default, handler: { (action:UIAlertAction) in
            if let storeContent = newItemAlert.textFields?.first?.text{
                
                
                //Setting cell content
                let store = GroceryStore(scontent: storeContent, saddedByUser: currentUsersEmail.currentUsersEmail)
                
                let itemRef = self.dbRef.child(storeContent.lowercased())
                
                itemRef.setValue(store.toAnyObject())
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
        
        return stores.count
    }

    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)

        let Item = stores[indexPath.row]
        
        cell.textLabel?.text = Item.scontent
        cell.detailTextLabel?.text = Item.saddedByUser

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            let Item = stores[indexPath.row]
            
            Item.itemRef?.removeValue()
        }
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Create a variable that you want to send based on the destination view controller
        // You can get a reference to the data by using indexPath shown below
        
        myIndex = indexPath.row
        stringMyIndex = String(myIndex)
        
        let segueName = "goodSegue"
        
        performSegue(withIdentifier: segueName, sender: self)
        
//
//        // Create an instance of PlayerTableViewController and pass the variable
//        let destinationVC = Store_Items()
//        destinationVC.StoreNames = stringMyIndex
//
//        let me = GroceryLists_TableViewController()
//
//
////        // Let's assume that the segue name is called playerSegue
////        // This will perform the segue and pre-load the variable for you to use
//        destinationVC.performSegue(withIdentifier: segueName, sender: indexPath.row)
        
    }
    

    
    
    
    
}
