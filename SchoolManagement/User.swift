//
//  User.swift
//  SchoolManagement
//
//  Created by Assistant on 05/11/25.
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    @NSManaged public var email: String
    @NSManaged public var password: String
}
