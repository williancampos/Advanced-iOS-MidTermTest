//
//  TitleCell.swift
//  MidTermTest
//
//  Created by Willian Campos (300879280) on 2017-03-07.
//  Copyright © 2017 Willian Campos. All rights reserved.
//
//  This class represents a title cell.
//  An title cell contains a UITextField representing the list name.

import UIKit

class TitleCell: UITableViewCell {
    
    @IBOutlet weak var listNameTextField: UITextField!
    
    var list: ShoppingList!
    
    @IBAction func nameTextFieldChanged(_ sender: UITextField) {
        list.name = sender.text!
    }
}
