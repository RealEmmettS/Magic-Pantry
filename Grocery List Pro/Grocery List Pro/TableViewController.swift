//
//  GroceryLists-TableViewController.swift
//  
//
//  Created by Emmett Shaughnessy on 7/12/18.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

//Defining Global Variables
var myIndex = 0
var stores = [GroceryStore]()
var currentUsersEmail = extraUserInfo(currentUsersEmail: "")
var stringMyIndex: String?
var stringStoreName: String?
var stringStoreNameForDeletion: String?
let user = Auth.auth().currentUser
var validationID = Auth.auth().currentUser!.uid




class GroceryLists_TableViewController: UITableViewController {
    
    //Defining Local Variables
    var dbRef:DatabaseReference!
    
    func reloadVerificationID(){
        validationID = Auth.auth().currentUser!.uid
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference().child("listStores-\(validationID)")
        startObservingDB()
    }
    
    func reloaddbRef(){
        reloadVerificationID()
        dbRef = Database.database().reference().child("listStores-\(validationID)")
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Auth.auth().addStateDidChangeListener { (auth:Auth?, user) in
            if let user = user {
                print("Welcome \(theUserEmail)!")
                currentUsersEmail.currentUsersEmail = theUserEmail
                self.startObservingDB()
            } else {
                print("You need to sign-up or login first!")
            }
        }
        
        
    }
    
    
    
    
    @IBAction func logInAndSignUp(_ sender: Any) {
        self.reloaddbRef()
        
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
                    print("ok. nu wurk. plz trie agen okey?")
                } else {
                    self.reloaddbRef()
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
                    print("ok. nu wurk. plz trie agen okey?")
                } else {
                    UserDefaults.standard.setValue(user?.uid, forKey: "uid")
                    self.reloaddbRef()
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
        validationID = ""
        self.reloaddbRef()
        self.tableView.reloadData()
        
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.tableView.reloadData()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            signOutNotificationERROR()
        }
        
        
    }
    
    //MARK: Notification Alerts
    
    //Sign Out Notification
    func signOutNotification() {
        let ErrorAlert = UIAlertController(title: "Successful", message: "Signed Out Successfully!", preferredStyle: .alert)
        
        ErrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(ErrorAlert, animated: true, completion: nil)
    }
    //Sign Out Error
    func signOutNotificationERROR() {
        let ErrorAlert = UIAlertController(title: "Error", message: "Sign Out Failed.\nPlease Try Again", preferredStyle: .alert)
        
        ErrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(ErrorAlert, animated: true, completion: nil)
    }
    //Sign in Notification
    func signInNotification() {
        let ErrorAlert = UIAlertController(title: "Successful", message: "Logged In Successfully!", preferredStyle: .alert)
        
        ErrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(ErrorAlert, animated: true, completion: nil)
    }
    //Sign in Error
    func signInNotificationERROR() {
        let ErrorAlert = UIAlertController(title: "Error", message: "Loggin Failed.\nTry Again", preferredStyle: .alert)
        
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
                let store = GroceryStore(scontent: storeContent, saddedByUser: (Auth.auth().currentUser?.uid)!)
                //Setting data in Firebase
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
       // GroceryStore.sort({$0.date.timeIntervalSinceNow < $1.date.timeIntervalSinceNow})

        let Item = stores[indexPath.row]
        
            cell.textLabel?.text = Item.scontent
            //Below, replace "" with currentUsersEmail.currentUsersEmail to make it display the users email who added it
            cell.detailTextLabel?.text = ""
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            let Item = stores[indexPath.row]
            Item.itemRef?.removeValue()
            
            //Setting up for store deletion
            let currentCellForDeletion = tableView.cellForRow(at: indexPath) as! UITableViewCell
            stringStoreNameForDeletion = currentCellForDeletion.textLabel?.text
            //Setting Item dbRef to the correct store
            dbRefI = Database.database().reference().child("\(stringStoreNameForDeletion!)-\(validationID)")
            //Deleting Store and Items
            dbRefI.removeValue()
        }
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Create a variable that you want to send based on the destination view controller
        // You can get a reference to the data by using indexPath shown below
        
        myIndex = indexPath.row
        stringMyIndex = String(myIndex)
        
        //Defining cell name variable
        let currentCell = tableView.cellForRow(at: indexPath) as! UITableViewCell
        
        stringStoreName = currentCell.textLabel?.text
        
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        let segueName1 = "goodSegue"
        performSegue(withIdentifier: segueName1, sender: self)
        
    }
    

    
    
    
    
}
