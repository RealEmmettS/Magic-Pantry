//
//  TableViewController.swift
//  CongressAppChallenge
//
//  Created by Emmett Shaughnessy on 10/31/19.
//  Copyright © 2019 Emmett Shaughnessy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

var currentListId = ""


class TableViewController: UITableViewController {

    var DocRef: DocumentReference!
    var db:Firestore!
    var listArray = [ReminderLists]()
    var list = [lists]()
    var email:String?
    var tableuserid:String?
    var AuthString:String? //Testing this for later. NOT YET IMPLEMENTED
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if Auth.auth().currentUser?.uid == nil{
            YouAreNotSignedIn()
        } else {
            email = (Auth.auth().currentUser?.email!)!
            tableuserid = Auth.auth().currentUser!.uid
            AuthString = "\(email!)-\(tableuserid!)" //^^^NOT YET IMPLEMENTED^^^
            
            
            db = Firestore.firestore()
                   //let listsRef = db.collection("users").document(self.tableuserid!).collection("lists")
                   print("hey")
                   listArray.removeAll()
                   print(listArray)
                   //LoadData()
                   print("Done Loading. Listening...")
                   checkForUpdates()
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refreshTable), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    
    
    //MARK: Extra Setup
    @IBAction func profilePressed(_ sender: Any) {
        self.performSegue(withIdentifier: "GoToProfile", sender: self)
    }
    
    @objc func refreshTable() {
        checkForUpdates()
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    
    
    
    
    
    //MARK: Loading Items
    func checkForUpdates(){
        db.collection("users").document("\(self.tableuserid!)").collection("lists").addSnapshotListener {
            querySnapshot, error in
            
            guard let collection = querySnapshot else {return}
            
            collection.documentChanges.forEach {
                diff in

                if diff.type == .added {
                    let property = (diff.document.get("listName") as! String?)!
                    let formattedProperty = ReminderLists(listName: property)
                    print("\n\n Print: \( formattedProperty ) \n\n")
                                           
                    let list = self.listArray
                    if let sameItem = list.first(where: { $0.listName == formattedProperty.listName }) {
                                               
                            print("\(sameItem) already exists")
                                               
                        } else {
                            self.listArray.append(formattedProperty)
                            print("\(formattedProperty.listName) Added")
                        }
                                           
                    DispatchQueue.main.async {
                        print("Here you go!")
                        self.tableView.reloadData()
                        print(self.listArray)
                    }

                } else {
                    print("Documents Were Empty/Deleted")
                    
                    if diff.type == .removed {
                        self.listArray.removeAll()
                        self.checkForUpdates()
                    }
                    
                    if diff.type == .modified {
                        self.listArray.removeAll()
                        self.checkForUpdates()
                    }
                     
                }
            }
                
            }
        }
    
    
    
    
     //MARK: Adding Items
    @IBAction func addList(_ sender: Any) {
        let alert = UIAlertController(title: "List Name", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "New List Name Goes Here"
        })

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            guard let NameOfList = alert.textFields?.first?.text!, !NameOfList.isEmpty else {return}
            
            let NewList = ReminderLists(listName: NameOfList)
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
            
            self.checkForUpdates()
            
        }))

        self.present(alert, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return listArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)

        let listData = listArray[indexPath.row]
        let errorText = "Error fetching list"
        
        cell.textLabel?.text = "\(listData.listName ?? errorText)"

        return cell
    }
    

   
    
    
    
    

    
    // Override to support editing/deleting the table view.
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let listRef = db.collection("users").document("\(self.tableuserid!)").collection("lists")
            
            listRef.getDocuments { (snapshotDocuments, err) in
                if let err = err{
                    print("Uh Oh. Can't Delete: \(err)")
                }
                
                let toDelete = self.listArray[indexPath.row].listName
            
                
                for document in snapshotDocuments!.documents{
                    
                    let property = (document.get("listName") as! String?)!
                    let formattedProperty = ReminderLists(listName: property)
                    
                    if formattedProperty.listName == toDelete {
                        
                        if self.db.collection("users").document("\(self.tableuserid!)").collection("lists").document(document.documentID).collection("Items") != nil{
                            
                            let items = self.db.collection("users").document("\(self.tableuserid!)").collection("lists").document(document.documentID).collection("Items")
                            items.getDocuments { (itemsDocuments, err) in
                            if let err = err{
                                print("Uh Oh. Can't Delete: \(err)")
                            }
                            for document in snapshotDocuments!.documents{
                                items.document(document.documentID).delete()
                                self.listArray.removeAll()
                                self.checkForUpdates()
                                tableView.reloadData()
                                }
                            }
                    
                        self.db.collection("users").document("\(self.tableuserid!)").collection("lists").document(document.documentID).delete()
                            self.listArray.removeAll()
                            self.checkForUpdates()
                            tableView.reloadData()
                            
                        } else {
                        self.db.collection("users").document("\(self.tableuserid!)").collection("lists").document(document.documentID).delete()
                            self.listArray.removeAll()
                            self.checkForUpdates()
                            tableView.reloadData()
                        }
                        
                    }
                }
                self.checkForUpdates()
                tableView.reloadData()
            }
            self.checkForUpdates()
            tableView.reloadData()
        }
        
        self.checkForUpdates()
        tableView.reloadData()
        //More editing styles
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
                    currentListId = document.documentID
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
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
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
    
    
    

}
