//
//  Category.swift
//  TodoeyAppP2
//
//  Created by Mirshad Ozuturk on 8/21/18.
//  Copyright © 2018 Mirshad Ozuturk. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>() // Creating items object so it hold to-many relationship, ex: One Category to-many Items
}
