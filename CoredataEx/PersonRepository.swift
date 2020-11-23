//
//  PersonRepository.swift
//  CoredataEx
//
//  Created by 김종권 on 2020/11/23.
//

import CoreData

class PersonModel: PersonModelStore {
    var id: String = ""
    var name: String = ""

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

class PersonRepository: PersonStore {
    let coreDataStack: CoreDataStack
    let maxCount: Int

    init(coreDataStack: CoreDataStack = CoreDataStack.shared, maxCount: Int = 10) {
        self.coreDataStack = coreDataStack
        self.maxCount = maxCount
    }

    func add(id: String, name: String) {
        let context = coreDataStack.taskContext()

        if let count = count(), count == maxCount {
            removeLast()
        }

        if let savedPlace = fetch(id, name, in: context) {
            savedPlace.updateDate = Date()
        } else {
            create(id, name, in: context)
        }

        context.performAndWait {
            do {
                try context.save()
            } catch {
                print("addPlace error: \(error)")
            }
        }
    }

    func remove(id: String, name: String) {
        let context = coreDataStack.taskContext()
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(id.length > 0 AND id == %@) OR (name == %@)", argumentArray: [id, name])

        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                context.delete(object)
            }
            try context.save()
        } catch _ {
            // error handling
        }
    }

    fileprivate func fetch(_ id: String, _ name: String, in context: NSManagedObjectContext) -> Person? {
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(id.length > 0 AND id == %@) OR (name == %@)", argumentArray: [id, name])
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("fetch for update Person error: \(error)")
            return nil
        }
    }

    fileprivate func create(_ id: String, _ name: String, in context: NSManagedObjectContext) {
        let place = Person(context: context)
        place.id = id
        place.name = name
        place.updateDate = Date()
    }

    func removeAll() {
        let context = coreDataStack.taskContext()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: Person.fetchRequest())

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("removeAll Person error: \(error)")
        }
    }

    func getPersons() -> [PersonModel] {
        return fetchAll().map {
            return PersonModel(id: $0.id ?? "1", name: $0.name ?? "2")
        }
    }

    fileprivate func fetchAll() -> [Person] {
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updateDate", ascending: false)]

        do {
            return try coreDataStack.viewContext.fetch(fetchRequest)
        } catch {
            print("fetch Person error: \(error)")
            return []
        }
    }

    func count() -> Int? {
        let context = coreDataStack.taskContext()
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        do {
            let count = try context.count(for: fetchRequest)
            return count
        } catch {
            print("count of Person error: \(error)")
            return nil
        }
    }

    func removeLast() {
        guard let removeTarget = fetchAll().last,
              let id = removeTarget.id,
              let name = removeTarget.name else {
            return
        }
        remove(
            id: id,
            name: name
        )
    }
}

