//
//  ViewController.swift
//  MidTermTest
//
//  Created by Willian Campos on 2017-03-07.
//  Copyright © 2017 Willian Campos. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var data: Array<Item> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        data = createInitialData()
    }
    
    func createInitialData() -> Array<Item> {
        return [Item("Item a", 5), Item("Item", 0), Item("Item", 0), Item("Item", 0), Item("Item", 0)]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1;
        case 1:
            return data.count;
        default:
            return 0;
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TitleCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
            let item = data[indexPath.row]
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
            self.data.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
        switchStatus.backgroundColor = UIColor.lightGray
        
        return [switchStatus]
    }

    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        data = createInitialData()
        tableView.reloadData()
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        data.append(Item("Item", 0))
        tableView.reloadData()
    
    }
}

