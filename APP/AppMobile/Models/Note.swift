//
//  Note.swift
//  FiekAppGr53
//
//  Created by Enis Hoxha on 2/26/24.
//  Copyright © 2024 Enis Hoxha. All rights reserved.
//

import CoreData

@objc(Note)
class Note:  NSManagedObject{
    @NSManaged var id: NSNumber!
    @NSManaged var title: String!
    @NSManaged var content: String!
    @NSManaged var user: User?
}
