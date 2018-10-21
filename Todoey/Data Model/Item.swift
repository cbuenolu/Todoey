//
//  Item.swift
//  Todoey
//
//  Created by Carlos Miguel Bueno Lujan on 20/10/2018.
//  Copyright © 2018 Carlos Miguel Bueno Lujan. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var selected : Bool = false
    @objc dynamic var title : String = ""
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
