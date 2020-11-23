//
//  PersonStore.swift
//  CoredataEx
//
//  Created by 김종권 on 2020/11/23.
//

// Domain

import CoreData

public protocol PersonModelStore {
    var id: String { get }
    var name: String { get }
}

public protocol PersonStore {
    func add(id: String, name: String)
    func remove(id: String, name: String)
    func removeAll()
    func count() -> Int?
    func removeLast()
}
