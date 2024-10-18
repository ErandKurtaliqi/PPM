//
//  User.swift
//  AppMobile
//
//  Created by Elda Reçica on 10/18/24.
//  Copyright © 2024 Elda Reçica. All rights reserved.
//

import CoreData

@objc(User)
class User:  NSManagedObject{
    @NSManaged var id: NSNumber!
    @NSManaged var name: String!
    @NSManaged var username: String!
    @NSManaged var password: NSNumber!
    @NSManaged var position: String!
    @NSManaged var notes: NSSet?
}
