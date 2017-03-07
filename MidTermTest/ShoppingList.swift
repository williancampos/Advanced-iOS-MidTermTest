//
//  ShoppingList.swift
//  MidTermTest
//
//  Created by Willian Campos (300879280) on 2017-03-07.
//  Copyright © 2017 Willian Campos. All rights reserved.
//
//  This class represents a shopping list. It has a name and an array of items.

import Foundation

class ShoppingList {
    
    var name: String
    var items: [Item]
    
    init(_ name: String, _ items: [Item]) {
        self.name = name
        self.items = items
    }
}
