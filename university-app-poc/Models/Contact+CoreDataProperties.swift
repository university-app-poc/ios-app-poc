//
//  Contact+CoreDataProperties.swift
//  university-app-poc
//
//  Created by Taha Chaudhry on 18/07/2023.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var email: String
    @NSManaged public var phone: String

}

extension Contact : Identifiable {

}
