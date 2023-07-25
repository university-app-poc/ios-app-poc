//
//  Course+CoreDataProperties.swift
//  university-app-poc
//
//  Created by Taha Chaudhry on 18/07/2023.
//
//

import Foundation
import CoreData


extension Course {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String
    @NSManaged public var university: University
    @NSManaged public var courseDescription: String
    @NSManaged public var duration: String
    @NSManaged public var entryRequirements: String

}

extension Course : Identifiable {

}
