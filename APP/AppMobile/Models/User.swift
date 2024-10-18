//
//  User.swift
//  FiekAppGr53
//
//  Created by Enis Hoxha on 2/28/24.
//  Copyright © 2024 Enis Hoxha. All rights reserved.
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
