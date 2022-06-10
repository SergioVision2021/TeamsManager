//
//  DataStoreManager.swift
//  TeamsManager
//
//  Created by Sergey Vysotsky on 10.06.2022.
//

import Foundation
import CoreData

class DataStoreManager {

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TeamsManager")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchEmployee() -> Employee {
        let position = Position(context: viewContext)
        position.name = "Developer"

        let location = Location(context: viewContext)
        location.name = "Gomel"

        let group = Group(context: viewContext)
        group.name = "Intervale"

        let employee = Employee(context: viewContext)
        employee.firstName = "Ivan"
        employee.lastName = "Ivanovich"
        employee.patronymic = "Ivanov"
        employee.experience = 1
        employee.rateCoefficient = false
        employee.rateHour = 0
        employee.age = 1
        employee.email = "name@email.com"
        employee.phone = "0"
        employee.about = ""
        
        employee.position = position
        employee.location = location
        employee.group = group

        return employee
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch let error{
            print(error)
        }
    }
    
    func add(name: String) {
        let group = Group(context: viewContext)
        group.name = name
    }
    
    func fetchGroup(callback: @escaping (Result<[Group], Error>) -> Void) {
        do {
            let data = try viewContext.fetch(Group.fetchRequest())
            callback(.success(data))
        } catch let error {
            callback(.failure(error))
        }
    }
}
