//
//  Note.swift
//  AppMobile
//
//  Created by Elda Reçica on 10/18/24.
//  Copyright © 2024 Elda Reçica. All rights reserved.
//

import CoreData

@objc(Note)
class Note:  NSManagedObject{
    @NSManaged var id: NSNumber!
    @NSManaged var title: String!
    @NSManaged var content: String!
    @NSManaged var user: User?
}
