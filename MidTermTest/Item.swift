//
//  Item.swift
//  MidTermTest
//
//  Created by Willian Campos (300879280) on 2017-03-07.
//  Copyright © 2017 Willian Campos. All rights reserved.
//
//  This class represents an list item. It has a name and a quantity.
//

import Foundation

class Item {
    
    var row: Int
    var name: String
    var quantity: Int
    
    init(_ row: Int, _ name: String, _ quantity: Int) {
        self.row = row
        self.name = name
        self.quantity = quantity
    }
}
