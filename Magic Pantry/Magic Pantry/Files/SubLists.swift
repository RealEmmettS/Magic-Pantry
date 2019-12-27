//
//  SubLists.swift
//  CongressAppChallenge
//
//  Created by Emmett Shaughnessy on 11/18/19.
//  Copyright © 2019 Emmett Shaughnessy. All rights reserved.
//

import UIKit
import Firebase

class SubLists: UITableViewController {
    
    var DocRef: DocumentReference!
    var db:Firestore!
    var itemArray = [ReminderLists]()
    var list = [lists]()
    var email:String?
    var tableuserid:String?
    var AuthString:String? //Testing this for later. NOT YET IMPLEMENTED
    var listImIn:CollectionReference?
    var listID = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.delegate = self
        tableView.dataSource = self
               
        email = (Auth.auth().currentUser?.email!)!
        tableuserid = Auth.auth().currentUser!.uid
        AuthString = "\(email!)-\(tableuserid!)" //Testing this for later. NOT YET IMPLEMENTED
               
        db = Firestore.firestore()
        listID = currentListId
        listImIn = db.collection("users").document(self.tableuserid!).collection("lists").document(listID).collection("Items")
        
        print("hey")
        itemArray.removeAll()
        print(itemArray)
        //LoadData()
        print("Done Loading. Listening...")
        checkForUpdates()
        
    }

    // MARK: - Table view data source
    
    
    func checkForUpdates(){
        listImIn!.addSnapshotListener {
                querySnapshot, error in
                
                guard let collection = querySnapshot else {return}
                
                collection.documentChanges.forEach {
                    diff in

                    if diff.type == .added {
                        let property = (diff.document.get("listName") as! String?)!
                        let formattedProperty = ReminderLists(listName: property)
                        print("\n\n Print: \( formattedProperty ) \n\n")
                                               
                        let list = self.itemArray
                        if let sameItem = list.first(where: { $0.listName == formattedProperty.listName }) {
                                                   
                                print("\(sameItem) already exists")
                                                   
                            } else {
                                self.itemArray.append(formattedProperty)
                                print("\(formattedProperty.listName) Added")
                            }
                                               
                        DispatchQueue.main.async {
                            print("Here you go!")
                            self.tableView.reloadData()
                            print(self.itemArray)
                        }

                    } else {
                        print("Documents Were Empty/Deleted")
                        
                        if diff.type == .removed {
                            self.itemArray.removeAll()
                            self.checkForUpdates()
                        }
                        
                        if diff.type == .modified {
                            self.itemArray.removeAll()
                            self.checkForUpdates()
                        }
                         
                    }
                }
                    
                }
            }
    
    
    
    //MARK: Adding Items
       @IBAction func addItem(_ sender: Any) {
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
            ref = self.listImIn!.addDocument(data: NewList.dictionary){
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
    
    
    
    
    
    
    
    
    

   override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)

        let listData = itemArray[indexPath.row]
        let errorText = "Error fetching list"
        
        cell.textLabel?.text = "\(listData.listName ?? errorText)"

        return cell
    }

    

}
