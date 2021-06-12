//
//  Lists(With Ads).swift
//  Magic Pantry
//
//  Created by Emmett Shaughnessy on 3/1/21.
//  Copyright © 2021 Emmett Shaughnessy. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleMobileAds
import Qonversion

//var currentListId = ""
//var currentListName = ""


class Lists_With_Ads_: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    ///////////////////////////
    //MARK: Ads Setup
    private let banner: GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = admobAppId
        if UserDefaults.standard.bool(forKey: "doRunAds") == true{
            print("\n\nRunning ads - initializing Google Ad Banner View\n\n")
            banner.load(GADRequest())
            banner.backgroundColor = .secondarySystemBackground
        }
        return banner
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UserDefaults.standard.bool(forKey: "doRunAds") == true{
            print("\n\nRunning ads - begin displaying ads through the Google Ad Banner View\n\n")
            banner.frame = CGRect(x: 0, y: view.frame.size.height - 50, width: view.frame.size.width, height: 50).integral
        }else{
            print("Won't run ads")
        }
        
    }
    
    //MARK: Qonversion Setup
    func checkQonversionStatus(){
        Qonversion.checkPermissions { (permissions, error) in
            if error != nil {
                // handle error
                print("Qonversion error")
                return
            }
            
            if let premium: Qonversion.Permission = permissions["Premium"], premium.isActive {
                switch premium.renewState {
                case .willRenew, .nonRenewable:
                    UserDefaults.standard.set(false, forKey: "doRunAds")
                    print("Qonversion: Premium Active")
                    break
                case .billingIssue:
                    // Grace period: permission is active, but there was some billing issue.
                    UserDefaults.standard.set(false, forKey: "doRunAds")
                    print("Qonversion: Premium Active")
                    // Prompt the user to update the payment method.
                    break
                case .cancelled:
                    // The user has turned off auto-renewal for the subscription, but the subscription has not expired yet.
                    // Prompt the user to resubscribe with a special offer.
                    UserDefaults.standard.set(false, forKey: "doRunAds")
                    print("Qonversion: Premium Active")
                    break
                default: break
                }
            }else{
                UserDefaults.standard.set(true, forKey: "doRunAds")
                print("Qonversion: Premium Not Active")
            }
        }
    }
    //////////////////////////
    
    var DocRef: DocumentReference!
    var db:Firestore!
    var listArray = [ReminderLists]()
    var list = [lists]()
    var email:String?
    var tableuserid:String?
    var AuthString:String? //Testing this for later. NOT YET IMPLEMENTED
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    func updateQonversionUser(){
        Qonversion.setUserID(Auth.auth().currentUser!.uid)
        Qonversion.setProperty(.email, value: Auth.auth().currentUser!.email!)
        print("Qonversion User: \(Auth.auth().currentUser!.uid)")
        
        Qonversion.checkPermissions { (permissions, error) in
            if let error = error {
                // handle error
                print("Qonversion error")
                return
            }
            
            if let premium: Qonversion.Permission = permissions["Premium"], premium.isActive {
                switch premium.renewState {
                case .willRenew, .nonRenewable:
                    UserDefaults.standard.set(false, forKey: "doRunAds")
                    print("Qonversion: Premium Active")
                    break
                case .billingIssue:
                    // Grace period: permission is active, but there was some billing issue.
                    UserDefaults.standard.set(false, forKey: "doRunAds")
                    print("Qonversion: Premium Active")
                    // Prompt the user to update the payment method.
                    break
                case .cancelled:
                    // The user has turned off auto-renewal for the subscription, but the subscription has not expired yet.
                    // Prompt the user to resubscribe with a special offer.
                    UserDefaults.standard.set(false, forKey: "doRunAds")
                    print("Qonversion: Premium Active")
                    break
                default: break
                }
            }else{
                UserDefaults.standard.set(true, forKey: "doRunAds")
                print("Qonversion: Premium Not Active")
            }
        }
    }
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        checkQonversionStatus()
        
        if UserDefaults.standard.bool(forKey: "doRunAds") == true {
            banner.rootViewController = self
            view.addSubview(banner)
        }else{
            bottomConstraint.constant = 0
            self.updateViewConstraints()
        }
        
        //overrideUserInterfaceStyle = .light
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if Auth.auth().currentUser?.uid == nil{
            YouAreNotSignedIn()
        } else {
            updateQonversionUser()
            email = (Auth.auth().currentUser?.email!)!
            tableuserid = Auth.auth().currentUser!.uid
            AuthString = "\(email!)-\(tableuserid!)" //^^^NOT YET IMPLEMENTED^^^
            
            
            db = Firestore.firestore()
            //let listsRef = db.collection("users").document(self.tableuserid!).collection("lists")
            print("Login Successful. Syncing lists...")
            listArray.removeAll()
            print(listArray) //Should be nil or at least empty
            //LoadData()
            print("Done Loading. Listening...")
            checkForUpdates()
        }
        
        //let tableView.refreshControl = UItableView.refreshControl()
        tableView.refreshControl?.addTarget(self, action:  #selector(refreshTable), for: .valueChanged)
        tableView.refreshControl = tableView.refreshControl
    }
    
    
    
    
    //MARK: Extra Setup
    @IBAction func profilePressed(_ sender: Any) {
        self.performSegue(withIdentifier: "GoToProfile", sender: self)
    }
    
    @objc func refreshTable() {
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
    
    
    
    
    
    
    //MARK: - Loading Items
    func checkForUpdates(){
        db.collection("users").document("\(self.tableuserid!)").collection("lists").addSnapshotListener {
            querySnapshot, error in
            
            guard let collection = querySnapshot else {return}
            
            collection.documentChanges.forEach {
                diff in
                
                if diff.type == .added {
                    print("Adding Lists")
                    let name = (diff.document.get("listName") as! String?)!
                    let id = (diff.document.documentID as! String?)!
                    let formattedProperty = ReminderLists(listName: name, id: id)
                    print("\n\n Print: \( formattedProperty ) \n\n")
                    
                    let list = self.listArray
                    if let sameItem = list.first(where: { $0.id == formattedProperty.id }) {
                        //This should never have to run - It's here just in case....
                        print("\(sameItem) already exists")
                        
                    } else {
                        //This should run
                        self.listArray.append(formattedProperty)
                        print("\(formattedProperty.listName) Added")
                    }
                    
                    DispatchQueue.main.async {
                        print("Here you go!")
                        self.tableView.reloadData()
                        print(self.listArray)
                    }
                    
                } else {
                    
                    
                    if diff.type == .removed {
                        print("Removing Items")
                        let name = (diff.document.get("listName") as! String?)!
                        let id = (diff.document.documentID as! String?)!
                        let formattedProperty = ReminderLists(listName: name, id:id)
                        
                        var index = 0
                        for i in self.listArray{
                            if i.id == formattedProperty.id{
                                print("Found at \(index)")
                                self.listArray.remove(at: index)
                            }
                            index += 1
                        }
                        self.tableView.reloadData()
                    }
                    
                    if diff.type == .modified {
                        print("Editing Items")
                        let name = (diff.document.get("listName") as! String?)!
                        let id = (diff.document.documentID as! String?)!
                        let formattedProperty = ReminderLists(listName: name, id:id)
                        
                        var index = 0
                        for i in self.listArray{
                            if i.id == formattedProperty.id{
                                print("Found at \(index)")
                                self.listArray[index].listName = formattedProperty.listName
                            }
                            index += 1
                        }
                        self.tableView.reloadData()
                        
                        
                    }//end of .modified
                    
                }
            }
            //sorry for the mess of curly brackets
        }
    }
    
    
    
    
    //MARK: - Adding Items
    @IBAction func addList(_ sender: Any) {
        let alert = UIAlertController(title: "New List", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "List Name"
        })
        
        alert.addAction(UIAlertAction(title: "Create List", style: .default, handler: { action in
            guard let NameOfList = alert.textFields?.first?.text!, !NameOfList.isEmpty else {return}
            
            let NewList = ReminderLists(listName: NameOfList)
            var alreadyExists = false;
            for i in self.listArray{
                if i.listName == NewList.listName{
                    alreadyExists = true
                } else {
                    alreadyExists = false
                }
            }
            if alreadyExists{
                let t = "Already Exists"
                let m = "A list with that name already exists"
                let a = "Ok"
                self.simpleAlert(title: t, message: m ,action: a)
            } else {
                print("\n\n\n\(NewList)\n\n\n\(NewList.dictionary)\n\n\n")
                var ref:DocumentReference? = nil
                ref = self.db.collection("users").document("\(self.tableuserid!)").collection("lists").addDocument(data: NewList.dictionary){
                    error in
                    if let error = error{
                        print("Error adding document: \(error.localizedDescription)")
                    } else {
                        print("Data Saved with ID: \(ref!.documentID)")
                    }
                }
            }
            
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Create Another", style: .default, handler: { action in
            guard let NameOfList = alert.textFields?.first?.text!, !NameOfList.isEmpty else {return}
            
            let NewList = ReminderLists(listName: NameOfList)
            var alreadyExists = false;
            for i in self.listArray{
                if i.listName == NewList.listName{
                    alreadyExists = true
                } else {
                    alreadyExists = false
                }
            }
            
            if alreadyExists{
                let t = "Already Exists"
                let m = "A list with that name already exists"
                let a = "Ok"
                self.simpleAlert(title: t, message: m ,action: a)
            } else {
                print("\n\n\n\(NewList)\n\n\n\(NewList.dictionary)\n\n\n")
                var ref:DocumentReference? = nil
                ref = self.db.collection("users").document("\(self.tableuserid!)").collection("lists").addDocument(data: NewList.dictionary){
                    error in
                    if let error = error{
                        print("Error adding document: \(error.localizedDescription)")
                    } else {
                        print("Data Saved with ID: \(ref!.documentID)")
                    }
                }
            }
            
            
            self.addList(self)
            
        }))
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return listArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        
        let listData = listArray[indexPath.row]
        let errorText = "Error fetching list"
        
        cell.textLabel?.text = "\(listData.listName ?? errorText)"
        
        return cell
    }
    
    
    
    
    
    
    
    
    //MARK: Deleting (Editing) Cells
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let listRef = self.db.collection("users").document("\(self.tableuserid!)").collection("lists")
        
        
        //Delete Option
        let delete = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            print("User chose to delete list")
            
            
            listRef.getDocuments { (snapshotDocuments, err) in
                print("Retrieving all avaliable lists")
                if let err = err{
                    print("Uh Oh. Can't Delete: \(err)")
                }
                
                let toDelete = self.listArray[indexPath.row].id
                print("Marked local list for deletion")
                
                
                for document in snapshotDocuments!.documents{
                    print("Beggining deletion sequence")
                    
                    //let property = (document.get("listName") as! String?)!
                    let name = (document.get("listName") as! String?)!
                    let id = (document.documentID as String?)!
                    let formattedProperty = ReminderLists(listName: name, id: id)
                    
                    print("Marked remote list for deletion")
                    print(formattedProperty.id)
                    print(toDelete!)
                    
                    if formattedProperty.id == toDelete {
                        //check items
                        print("Attempting delete")
                        if self.db.collection("users").document("\(self.tableuserid!)").collection("lists").document(document.documentID).collection("Items") != nil{ //checking if list is empty
                            
                            let items = self.db.collection("users").document("\(self.tableuserid!)").collection("lists").document(document.documentID).collection("Items")
                            
                            //Delete items
                            print("Deleting items in list")
                            items.getDocuments { (itemsDocuments, err) in
                                if let err = err{
                                    print("Uh Oh. Can't Delete: \(err)")
                                }
                                for document in snapshotDocuments!.documents{
                                    items.document(document.documentID).delete()
                                }
                            }
                            
                            
                            //Delete List
                            print("Deleting list")
                            self.db.collection("users").document("\(self.tableuserid!)").collection("lists").document(document.documentID).delete()
                            
                            self.listArray.remove(at: indexPath.row)
                            
                        } /* end check items */else {
                            //Runs only if list is already empty
                            self.db.collection("users").document("\(self.tableuserid!)").collection("lists").document(document.documentID).delete()
                            
                            self.listArray.remove(at: indexPath.row)
                        }
                        
                    }
                }
            }
        }
        
            
            
            
        //Edit Option
        let edit = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            let itemName = self.listArray[indexPath.row].listName
            self.getNewItemName(itemSelected: indexPath.row, currentName: itemName)
            
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [delete, edit])
        return swipeActions
    }
    
    
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        print("User began edit")
//        if editingStyle == .delete {
//            print("User chose to delete list")
//
//            let listRef = db.collection("users").document("\(self.tableuserid!)").collection("lists")
//
//            listRef.getDocuments { (snapshotDocuments, err) in
//                print("Retrieving all avaliable lists")
//                if let err = err{
//                    print("Uh Oh. Can't Delete: \(err)")
//                }
//
//                let toDelete = self.listArray[indexPath.row].id
//                print("Marked local list for deletion")
//
//
//                for document in snapshotDocuments!.documents{
//                    print("Beggining deletion sequence")
//
//                    //let property = (document.get("listName") as! String?)!
//                    let name = (document.get("listName") as! String?)!
//                    let id = (document.documentID as String?)!
//                    let formattedProperty = ReminderLists(listName: name, id: id)
//
//                    print("Marked remote list for deletion")
//                    print(formattedProperty.id)
//                    print(toDelete!)
//
//                    if formattedProperty.id == toDelete {
//                        //check items
//                        print("Attempting delete")
//                        if self.db.collection("users").document("\(self.tableuserid!)").collection("lists").document(document.documentID).collection("Items") != nil{ //checking if list is empty
//
//                            let items = self.db.collection("users").document("\(self.tableuserid!)").collection("lists").document(document.documentID).collection("Items")
//
//                            //Delete items
//                            print("Deleting items in list")
//                            items.getDocuments { (itemsDocuments, err) in
//                                if let err = err{
//                                    print("Uh Oh. Can't Delete: \(err)")
//                                }
//                                for document in snapshotDocuments!.documents{
//                                    items.document(document.documentID).delete()
//                                }
//                            }
//
//
//                            //Delete List
//                            print("Deleting list")
//                            self.db.collection("users").document("\(self.tableuserid!)").collection("lists").document(document.documentID).delete()
//
//                            self.listArray.remove(at: indexPath.row)
//
//                        } /* end check items */else {
//                            //Runs only if list is already empty
//                            self.db.collection("users").document("\(self.tableuserid!)").collection("lists").document(document.documentID).delete()
//
//                            self.listArray.remove(at: indexPath.row)
//                        }
//
//                    }
//                }
//            }
//        }
//        //More editing styles
//
//        //Edit Option
//        if editingStyle == .
//    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedList = indexPath.row
        
        let listRef = db.collection("users").document("\(self.tableuserid!)").collection("lists")
        
        listRef.getDocuments { (snapshotDocuments, err) in
            if let err = err{
                print("Uh Oh. Can't Delete: \(err)")
            }
            
            let toSelect = self.listArray[indexPath.row].listName
            
            
            for document in snapshotDocuments!.documents{
                
                let property = (document.get("listName") as! String?)!
                let formattedProperty = ReminderLists(listName: property)
                
                if formattedProperty.listName == toSelect {
                    let property = (document.get("listName") as! String?)!
                    currentListId = document.documentID
                    currentListName = property
                    self.performSegue(withIdentifier: "sublists", sender: self)
                }
            }
        }
        
    }
    
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    
    
    // Override to support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }
    
    
    //MARK: Extra Functions
    func YouAreNotSignedIn(){
        let alertController = UIAlertController(title: "Not Signed In", message:
                                                    "Please sign in by clicking the button below", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Sign-In", style: .default, handler: { action in
            self.performSegue(withIdentifier: "GoToProfile", sender: self)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func simpleAlert(title: String, message: String, action: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: action, style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func getNewItemName(itemSelected: Int, currentName: String?){
        let alert = UIAlertController(title: "Edit Item", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "New Item Name"
            if currentName != nil{
                textField.text = currentName
            }
        })
        
        var newName:String?
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
            guard let NameOfList = alert.textFields?.first?.text!, !NameOfList.isEmpty else {return}
            
            let NewList = ReminderLists(listName: NameOfList)
            print("\n\n\n\(NewList)\n\n\n\(NewList.dictionary)\n\n\n")
            newName = NameOfList
            
            
            
            //Begin Editing
            let listRef = self.db.collection("users").document("\(self.tableuserid!)").collection("lists")
            
            listRef.getDocuments { (snapshotDocuments, err) in
            if let err = err{
                print("Uh Oh. Can't Edit: \(err)")
            }
            
                
            guard let toEdit = self.listArray[itemSelected].listName else {return}
            
                
            for document in snapshotDocuments!.documents{
                
                //The following checks to make sure item to edit actually exists locally
                //Pretend listName says itemName
                let property = (document.get("listName") as! String?)!
                let formattedProperty = ReminderLists(listName: property)

                if formattedProperty.listName == toEdit {
                    
                    //self.listImIn?.document(document.documentID).delete()
                    listRef.document(document.documentID).setData([ "listName": NameOfList ], merge: true)
                    self.listArray[itemSelected].listName = NameOfList
                    //LoadData()
                    print("Done Loading.")

                }
            }
                
                
            }
            
            
            
        }))
        self.present(alert, animated: true)
    }
        
        
    
    
    
    
    
    
    
    
    
    
}

