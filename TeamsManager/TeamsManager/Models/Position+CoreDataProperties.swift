//
//  Position+CoreDataProperties.swift
//  TeamsManager
//
//  Created by Sergey Vysotsky on 10.06.2022.
//
//

import Foundation
import CoreData


extension Position {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Position> {
        return NSFetchRequest<Position>(entityName: "Position")
    }

    @NSManaged public var name: String?
    @NSManaged public var employee: NSSet?

}

// MARK: Generated accessors for employee
extension Position {

    @objc(addEmployeeObject:)
    @NSManaged public func addToEmployee(_ value: Employee)

    @objc(removeEmployeeObject:)
    @NSManaged public func removeFromEmployee(_ value: Employee)

    @objc(addEmployee:)
    @NSManaged public func addToEmployee(_ values: NSSet)

    @objc(removeEmployee:)
    @NSManaged public func removeFromEmployee(_ values: NSSet)

}

extension Position : Identifiable {

}
