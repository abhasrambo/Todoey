//
//  Category.swift
//  Todo-Realm
//
//  Created by Abhas Kumar on 6/6/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
