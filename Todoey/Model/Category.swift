//
//  Category.swift
//  Todoey
//
//  Created by Mircea Zahacinschi on 02.12.18.
//  Copyright © 2018 Mircea Zahacinschi. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var categoryName: String = ""
    
    let items = List<Item>()
    
}
