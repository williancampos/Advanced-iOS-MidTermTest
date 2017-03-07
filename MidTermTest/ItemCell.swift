//
//  ItemCell.swift
//  MidTermTest
//
//  Created by Willian Campos (300879280) on 2017-03-07.
//  Copyright © 2017 Willian Campos. All rights reserved.
//
//  This class represents an item cell.
//  An item cell contains the a UITextField representing the Item name, a UILabel representing the Item quantity and a UIStepper allowing the user to change the quantity
//

import UIKit

class ItemCell: UITableViewCell {
    
    
    @IBOutlet weak var itemNameTextField: UITextField!
    
    @IBOutlet weak var itemQtLabel: UILabel!
    
    @IBOutlet weak var itemQtStepper: UIStepper!
    
    var item: Item!
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        let quantity = Int(sender.value)
        itemQtLabel.text = quantity.description
        item.quantity = quantity
    }
    

    @IBAction func nameTextFieldChanged(_ sender: UITextField) {
        item.name = sender.text!
    }
}
