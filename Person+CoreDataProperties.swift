//
//  Person+CoreDataProperties.swift
//  CoredataEx
//
//  Created by 김종권 on 2020/11/23.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var updateDate: Date?

}

extension Person : Identifiable {

}
