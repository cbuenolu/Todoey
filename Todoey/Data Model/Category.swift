//
//  Category.swift
//  Todoey
//
//  Created by Carlos Miguel Bueno Lujan on 20/10/2018.
//  Copyright © 2018 Carlos Miguel Bueno Lujan. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
