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

    func fetchFilter(callback: @escaping (Result<[Employee], Error>) -> Void) {
        do {
            let request = Employee.fetchRequest()

            //Set the filtering and sorting on the request
            //let predicate = NSPredicate(format: "firstName CONTAINS 'AepdLC'")

                //Get groups
                //Take one
                let reqGroup = Group.fetchRequest()
                let d = try viewContext.fetch(reqGroup)
                let gr = d[0]
            
            
            let predicate = NSPredicate(format: "%K == %@", "group.name", "Intervale")
            request.predicate = predicate
            
//            let sort = NSSortDescriptor(key: "name", ascending: true)
//            request.sortDescriptors = [sort]
            
            let data = try viewContext.fetch(request)
            
            
            callback(.success(data))
        } catch let error {
                callback(.failure(error))
        }
    }
    
    func fetchEmployee(callback: @escaping (Result<[Employee], Error>) -> Void) {
        do {
            //let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
            
            let data = try viewContext.fetch(Employee.fetchRequest())
            callback(.success(data))
        } catch let error {
            callback(.failure(error))
        }
    }
    
    func fetchGroup(callback: @escaping (Result<[Group], Error>) -> Void) {
        do {
            let request = Group.fetchRequest()
            
            //Sorting
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            
            //Fetching
            let data = try viewContext.fetch(request)
            callback(.success(data))
        } catch let error {
            callback(.failure(error))
        }
    }

    func add(_ name: String) {
        let obj = Group(context: viewContext)
        obj.name = name
    }
    
    func insert(_ obj: Group) {
        viewContext.insert(obj)
        print("insert \(obj)")
    }
    
    func delete(_ obj: Group) {
        viewContext.delete(obj)
        print("delete \(obj)")
    }

    func deleteAll() {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: Group.fetchRequest())
        do {
            try viewContext.execute(deleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func addDefault() {
        
        func randomString(length: Int) -> String {
          let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
          return String((0..<length).map{ _ in letters.randomElement()! })
        }
        
        let position = Position(context: viewContext)
        position.name = "HR"
        
        let location = Location(context: viewContext)
        location.name = "Gomel"
        
        let group = Group(context: viewContext)
        group.name = "Intervale"
        
        let obj = Employee(context: viewContext)
        obj.firstName = randomString(length: 6)
        obj.lastName = "lastName"
        obj.patronymic = "patronynic"
        obj.experience = 1
        obj.rateCoefficient = false
        obj.rateHour = 0
        obj.age = 1
        obj.email = "name@email.com"
        obj.phone = "0"
        obj.about = ""
        
        obj.position = position
        obj.location = location
        obj.group = group
    }
}
