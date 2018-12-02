//
//  Item.swift
//  Todoey
//
//  Created by Mircea Zahacinschi on 02.12.18.
//  Copyright © 2018 Mircea Zahacinschi. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var done: Bool = false
    @objc dynamic var title: String = ""
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") // See lecture 248 for more info
    
}

