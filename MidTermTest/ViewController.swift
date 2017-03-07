//
//  ViewController.swift
//  MidTermTest
//
//  Created by Willian Campos (300879280) on 2017-03-07.
//  Copyright © 2017 Willian Campos. All rights reserved.
//
//  This is the controller for the shopping list screen.
//  It is responsible for database persistence handling as well.
//  Delete handling is implemented using swipe left on table row.


import UIKit

class ViewController: UITableViewController {
    
    var data: ShoppingList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let database = connectToDatabase()
        
        //Create item table in case it does not exist
        let createSQL = "CREATE TABLE IF NOT EXISTS ITEM (ROW INTEGER PRIMARY KEY, NAME TEXT, QUANTITY INTEGER); " +
            "CREATE TABLE IF NOT EXISTS LIST (NAME TEXT PRIMARY KEY);"
        var errMsg:UnsafeMutablePointer<Int8>? = nil
        let result = sqlite3_exec(database, createSQL, nil, nil, &errMsg)
        if (result != SQLITE_OK) {
            sqlite3_close(database)
            print("Failed to create table")
            return
        }
        
        //Set initial data
        data = getInitialData(database)
        
        sqlite3_close(database)
        
    }
    
    //Method responsible for connecting to database
    func connectToDatabase() -> OpaquePointer? {
        //Connect to database
        var database:OpaquePointer? = nil
        let result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open database")
            return nil
        }
        return database
    }
    
    //Method responsible for return database file URL
    func dataFilePath() -> String {
        let urls = FileManager.default.urls(for:
            .documentDirectory, in: .userDomainMask)
        var url:String?
        url = urls.first?.appendingPathComponent("data.plist").path
        return url!
    }
    
    // This method persist on database the current state of the shopping list
    func persistCurrentState() {
        let database = connectToDatabase()
        
        //Clear database task data
        let delete = "delete from ITEM; delete from LIST;"
        var deleteStatement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, delete, -1, &deleteStatement, nil) == SQLITE_OK {
        }
        if sqlite3_step(deleteStatement) != SQLITE_DONE {
            print("Error delete data")
            NSLog("Database Error Message : %s", sqlite3_errmsg(database))
            return
        }
        sqlite3_finalize(deleteStatement)
        
        // Persist the list name
        let listUpdate = "INSERT OR REPLACE INTO LIST (NAME) " +
        "VALUES (?);"
        var listStatement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, listUpdate, -1, &listStatement, nil) == SQLITE_OK {
            let name = data.name
            sqlite3_bind_text(listStatement, 1, (name as NSString).utf8String, -1, nil)
        }
        if sqlite3_step(listStatement) != SQLITE_DONE {
            print("Error updating table")
            NSLog("Database Error Message : %s", sqlite3_errmsg(database))
            sqlite3_close(database)
            return
        }
        
        sqlite3_finalize(listStatement)
        
        
        
        //Persist all the items in current state
        for i in 0..<data.items.count  {
            let item = data.items[i]
            let update = "INSERT OR REPLACE INTO ITEM (ROW, NAME, QUANTITY) " +
            "VALUES (?, ?, ?);"
            var statement:OpaquePointer? = nil
            if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK {
                let name = item.name
                let quantity = item.quantity
                sqlite3_bind_int(statement, 1, Int32(i))
                sqlite3_bind_text(statement, 2, (name as NSString).utf8String, -1, nil)
                sqlite3_bind_int(statement, 3, Int32(quantity))
            }
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error updating table")
                NSLog("Database Error Message : %s", sqlite3_errmsg(database))
                sqlite3_close(database)
                return
            }
            
            sqlite3_finalize(statement)
        }
        
        //Close connection with database
        sqlite3_close(database)
    }

    
    // Retrieve initial data from database. If there is nothing persisted on database, returns a default list.
    func getInitialData(_ database: OpaquePointer?) -> ShoppingList {
        let listQuery = "SELECT NAME FROM LIST"
        var listStatement:OpaquePointer? = nil
        
        var tempListName: String?
        if sqlite3_prepare_v2(database, listQuery, -1, &listStatement, nil) == SQLITE_OK {
            while sqlite3_step(listStatement) == SQLITE_ROW {
                tempListName = String.init(cString: sqlite3_column_text(listStatement, 0)!)
            }
            sqlite3_finalize(listStatement)
        } else {
            print("Error")
            NSLog("Database Error Message : %s", sqlite3_errmsg(database))
        }

        if let listName = tempListName {
            //Populate item table with database items
            let query = "SELECT ROW, NAME, QUANTITY FROM ITEM ORDER BY ROW"
            var statement:OpaquePointer? = nil
            var items: Array<Item> = []
            if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let row = Int(sqlite3_column_int(statement, 0))
                    let name = String.init(cString: sqlite3_column_text(statement, 1)!)
                    let quantity: Int = Int(sqlite3_column_int(statement, 2))
                    items.append(Item(row, name, quantity))
                }
                sqlite3_finalize(statement)
            }
            
            sqlite3_close(database)
            
            return ShoppingList(listName, items)
            
        } else {
            return ShoppingList("Shopping List", [Item(0, "Item 1", 0), Item(1, "Item 2", 0), Item(2, "Item 3", 0), Item(3, "Item 4", 0), Item(4, "Item 5", 0)])
        }
    }
  
    
    // This method returns the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    //This method returns the number of rows in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1;
        case 1:
            return data.items.count;
        default:
            return 0;
        }
    }
    
    //This method defines the height for section headers
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    //This method is responsible for presenting the adequate section header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let  headerCell = tableView.dequeueReusableCell(withIdentifier: "TitleCellHeader")
            return headerCell
        default:
            let  headerCell = tableView.dequeueReusableCell(withIdentifier: "ItemCellHeader")
            return headerCell
        }
        
    }
    
    //This method is responsible for retrieving the adequate cell for presenting on screen
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TitleCell
            cell.list = data
            cell.listNameTextField.text = data.name
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
            let item = data.items[indexPath.row]
            cell.item = item
            cell.itemNameTextField.text = item.name
            cell.itemQtLabel.text = String(item.quantity)
            cell.itemQtStepper.value = Double(item.quantity)
            
            return cell
        }
        
    }
    
    // This method is responsible for adding an action for delete item once detected a swipe left gesture on row.
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if (indexPath.section == 0) {
            return nil
        }
        
        let actionStr = "Delete"
        let switchStatus = UITableViewRowAction(style: .destructive, title: actionStr) { action, index in
            self.data.items.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
        switchStatus.backgroundColor = UIColor.lightGray
        
        return [switchStatus]
    }

    //This method restore the initial data when cancel button is pressed
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let database = connectToDatabase()
        data = getInitialData(database)
        tableView.reloadData()
    }
    
    //This method perist the current data when save button is pressed
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        persistCurrentState()
    }
    
    //This method adds a new item on the list when add button is pressed
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        data.items.append(Item(data.items.count, "Item", 0))
        tableView.reloadData()
    
    }
    
}

