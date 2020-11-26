//
//  SubLists.swift
//  CongressAppChallenge
//
//  Created by Emmett Shaughnessy on 11/18/19.
//  Copyright © 2020 Emmett Shaughnessy. All rights reserved.
//

import Foundation
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
    
    //@IBOutlet weak var NavBarTitle: UILabel!
    @IBOutlet weak var NavBarTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //overrideUserInterfaceStyle = .light
        
        //Makes the page title match the current list name
        NavBarTitle.title = currentListName
        
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
        print("Array: \(itemArray)")
        //LoadData()
        print("Done Loading. Listening...")
        checkForUpdates()
        
    }
    
    // MARK: - Loading Items
    func checkForUpdates(){
        listImIn!.addSnapshotListener {
                querySnapshot, error in
                
                guard let collection = querySnapshot else {return}
                
                collection.documentChanges.forEach {
                    diff in

                    if diff.type == .added {
                        print("Adding Items")
                        let name = (diff.document.get("listName") as! String?)!
                        let id = (diff.document.documentID as! String?)!
                        let formattedProperty = ReminderLists(listName: name, id: id)
                        print("\n\n Print: \( formattedProperty ) \n\n")
                                               
                        let list = self.itemArray
                        if let sameItem = list.first(where: { $0.id == formattedProperty.id }) {
                                //This should never have to run - It's here just in case....
                                print("\(sameItem) already exists")
                                                   
                            } else {
                                //This should run
                                self.itemArray.append(formattedProperty)
                                print("\(formattedProperty.listName) Added")
                            }
                                               
                        DispatchQueue.main.async {
                            print("Here you go!")
                            self.tableView.reloadData()
                            print(self.itemArray)
                        }

                    } else {
                        
                        if diff.type == .removed {
                            print("Removing Items")
                            let name = (diff.document.get("listName") as! String?)!
                            let id = (diff.document.documentID as! String?)!
                            let formattedProperty = ReminderLists(listName: name, id:id)
                            
                            var index = 0
                            for i in self.itemArray{
                                if i.id == formattedProperty.id{
                                    print("Found at \(index)")
                                    self.itemArray.remove(at: index)
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
                            for i in self.itemArray{
                                if i.id == formattedProperty.id{
                                    print("Found at \(index)")
                                    self.itemArray[index].listName = formattedProperty.listName
                                }
                                index += 1
                            }
                            self.tableView.reloadData()
                            

                        }
                         
                    }
                }
                    
                }
            }
    
    
    
    //MARK: - Adding Items
       @IBAction func addItem(_ sender: Any) {
           let alert = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))

           alert.addTextField(configurationHandler: { textField in
               textField.placeholder = "Item Name"
           })
        
           alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
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
               
               
               
           }))
        
        alert.addAction(UIAlertAction(title: "Add Another", style: .default, handler: { action in
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
            
            
            self.addItem(self)
            
        }))

           self.present(alert, animated: true)
       }
    
    
    
    
    
    
    
    
    
    //MARK: - TableView Stuff
   override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        
        let listData = itemArray[indexPath.row]
        let errorText = "Error fetching item(s)"
        
        cell.textLabel?.text = "\(listData.listName ?? errorText)"
        //cell.detailTextLabel?.text = "\(listData.category ?? errorText)"

        return cell
    }
    
    
    
//    MARK: Deleting (Editing) Cells
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //Delete Option
        let delete = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            let itemRef = self.listImIn!

            itemRef.getDocuments { (snapshotDocuments, err) in
                if let err = err{
                    print("Uh Oh. Can't Delete: \(err)")
                }

                guard let toDelete = self.itemArray[indexPath.row].id else {return}


                for document in snapshotDocuments!.documents{

                    //Pretend listName says itemName (it represents items in the lists not the list itself)
                    let name = (document.get("listName") as! String?)!
                    let id = (document.documentID as String?)!
                    //let cat = (document.get("category") as! String?)!
                    let formattedProperty = ReminderLists(listName: name, id: id)

                    if formattedProperty.id == toDelete {

                     self.listImIn?.document(document.documentID).delete()
                     self.itemArray.remove(at: indexPath.row)
                     //LoadData()
                     print("Done Loading.")

                    }
                }

            }
        }
        
        //Edit Option
        let edit = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            self.getNewItemName(itemSelected: indexPath.row)
            
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [delete, edit])
        return swipeActions
    }
    
    
    //MARK: - Extra Functions
    func getNewItemName(itemSelected: Int){
        let alert = UIAlertController(title: "Edit Item", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "New Item Name"
        })
        
        var newName:String?
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
            guard let NameOfList = alert.textFields?.first?.text!, !NameOfList.isEmpty else {return}
            
            let NewList = ReminderLists(listName: NameOfList)
            print("\n\n\n\(NewList)\n\n\n\(NewList.dictionary)\n\n\n")
            newName = NameOfList
            
            //Begin Editing
            let itemRef = self.listImIn!
            itemRef.getDocuments { (snapshotDocuments, err) in
            if let err = err{
                print("Uh Oh. Can't Edit: \(err)")
            }
            
                
            guard let toEdit = self.itemArray[itemSelected].listName else {return}
            
                
            for document in snapshotDocuments!.documents{
                
                //The following checks to make sure item to edit actually exists locally
                //Pretend listName says itemName
                let property = (document.get("listName") as! String?)!
                let formattedProperty = ReminderLists(listName: property)

                if formattedProperty.listName == toEdit {
                    
                    //self.listImIn?.document(document.documentID).delete()
                    self.listImIn?.document(document.documentID).setData([ "listName": NameOfList ], merge: true)
                    self.itemArray[itemSelected].listName = NameOfList
                    //LoadData()
                    print("Done Loading.")

                }
            }
                
                
            }
            
            
            
        }))
        self.present(alert, animated: true)
    }
    
    func getNewItemNameARRAY() -> ReminderLists {
        let alert = UIAlertController(title: "Edit Item", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "New Item Name"
        })
        
        var newName:ReminderLists?
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
            guard let NameOfList = alert.textFields?.first?.text!, !NameOfList.isEmpty else {return}
            
            let NewList = ReminderLists(listName: NameOfList)
            print("\n\n\n\(NewList)\n\n\n\(NewList.dictionary)\n\n\n")
            newName = NewList
            
            
            
        }))
        self.present(alert, animated: true)
        return newName!
    }
    

    

}
