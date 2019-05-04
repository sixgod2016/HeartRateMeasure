//
//  CoreDataOperation.swift
//  HeartCare
//
//  Created by 六神 on 2019/5/3.
//  Copyright © 2019 222. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataOperation {
    static let instance = CoreDataOperation()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }
    
    private init() {}
    
    func save() {
        do {
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func insert(_ arr:[Int]) {
        let data = NSEntityDescription.insertNewObject(forEntityName: "Record", into: context) as! Record
        data.id = Date()
        data.arr = arr
        save()
    }
    
    func delete(_ id: Date) {
        let result = select(id)
        for info in result {
            context.delete(info)
        }
        save()
    }
    
    func edit(_ id: Date, _ arr: [Int]) {
        let result = select(id)
        for item in result {
            item.arr = arr
        }
        save()
    }
    
    func selectAll() -> [Record] {
        do {
            let result = try context.fetch(getRequest())
            return result
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func select(_ date: Date) -> [Record] {
        let predicate = NSPredicate(format: "id = '\(date)'")
        let request = getRequest()
        request.predicate = predicate
        do {
            let result = try context.fetch(request)
            return result
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
