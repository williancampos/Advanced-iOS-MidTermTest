//
//  ItemCell.swift
//  MidTermTest
//
//  Created by Willian Campos on 2017-03-07.
//  Copyright © 2017 Willian Campos. All rights reserved.
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
