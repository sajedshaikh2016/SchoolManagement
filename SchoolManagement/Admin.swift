//
//  Admin.swift
//  SchoolManagement
//
//  Created by Assistant on 12/11/25.
//

import Foundation
import CoreData

@objc(Admin)
public class Admin: NSManagedObject {
    @NSManaged public var username: String
    @NSManaged public var password: String
}
