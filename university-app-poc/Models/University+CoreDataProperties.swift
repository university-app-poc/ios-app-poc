//
//  University+CoreDataProperties.swift
//  university-app-poc
//
//  Created by Taha Chaudhry on 18/07/2023.
//
//

import Foundation
import CoreData


extension University {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<University> {
        return NSFetchRequest<University>(entityName: "University")
    }
    
    @NSManaged public var id: Int16
    @NSManaged public var name: String
    @NSManaged public var address: String
    @NSManaged public var contact: Contact

}

extension University : Identifiable {

}
