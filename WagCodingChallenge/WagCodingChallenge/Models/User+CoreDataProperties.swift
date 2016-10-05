//
//  User+CoreDataProperties.swift
//  WagCodingChallenge
//
//  Created by James Ajhar on 10/4/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var id: Int32
    @NSManaged public var username: String?
    @NSManaged public var bronzeBadgeCount: Int32
    @NSManaged public var silverBadgeCount: Int32
    @NSManaged public var goldBadgeCount: Int32
    @NSManaged public var avatarURLString: String?

}
