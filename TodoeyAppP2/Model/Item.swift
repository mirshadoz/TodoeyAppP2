//
//  Item.swift
//  TodoeyAppP2
//
//  Created by Mirshad Ozuturk on 8/21/18.
//  Copyright © 2018 Mirshad Ozuturk. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") // Setting up parentCategory relationship from Category.self "type", via "items" property in Category model - reverse relationship
}
