//
//  Employee+CoreDataProperties.swift
//  TeamsManager
//
//  Created by Sergey Vysotsky on 10.06.2022.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var about: String?
    @NSManaged public var age: Int16
    @NSManaged public var email: String?
    @NSManaged public var experience: Int16
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var patronymic: String?
    @NSManaged public var phone: String?
    @NSManaged public var rateCoefficient: Bool
    @NSManaged public var rateHour: Int16
    @NSManaged public var group: Group?
    @NSManaged public var location: Location?
    @NSManaged public var position: Position?

}

extension Employee : Identifiable {

}
