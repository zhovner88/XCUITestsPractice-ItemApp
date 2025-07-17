//
//  UIIdentifiers.swift
//  Shared
//
//  Created by Denys Zhovnerovych on 2025-07-17.
//

import Foundation

public enum UIIdentifiers {
    public enum ItemList {
        public static let itemList = "ItemList.itemList"
        public static let addButton = "ItemList.button.add"
        public static let deleteButton = "ItemList.button.delete"
        
        public static func item(_ name: String) -> String {
            "ItemList.item.\(name)"
        }
    }
    
    public enum AddNewItem {
        public static let addButton = "AddNewItem.button.add"
        public static let itemNameTextField = "AddNewItem.textfield.itemName"
        public static let sheet = "AddNewItem.sheet.shown"
    }
} 