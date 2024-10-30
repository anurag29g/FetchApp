//
//  FetchListAppTests.swift
//  FetchListAppTests
//
//  Created by Anurag Ghadge on 10/14/24.
//

import XCTest
import CoreData
@testable import FetchListApp

class CoreDataManagerTests: XCTestCase {
    var coreDataManager: CoreDataManager!

    override func setUp() {
        super.setUp()
        
        coreDataManager = CoreDataManager.createInMemoryManager()
    }

    override func tearDown() {
        coreDataManager = nil
        super.tearDown()
    }

    func testSavingItemToCoreData() {
        let newItem = CachedItem(context: coreDataManager.context)
        newItem.id = 1
        newItem.listId = 2
        newItem.name = "Test Item"

        coreDataManager.saveContext()

        let fetchRequest: NSFetchRequest<CachedItem> = CachedItem.fetchRequest()
        let results = try? coreDataManager.context.fetch(fetchRequest)

        XCTAssertEqual(results?.count, 1, "There should be one item in Core Data.")
        XCTAssertEqual(results?.first?.name, "Test Item", "The item's name should match.")
        XCTAssertEqual(results?.first?.listId, 2, "The item's listId should be 2.")
    }

    func testLoadingItemsFromCoreData() {
        let item1 = CachedItem(context: coreDataManager.context)
        item1.id = 1
        item1.listId = 2
        item1.name = "Test Item 1"

        let item2 = CachedItem(context: coreDataManager.context)
        item2.id = 2
        item2.listId = 2
        item2.name = "Test Item 2"

        coreDataManager.saveContext()

        let fetchRequest: NSFetchRequest<CachedItem> = CachedItem.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        let results = try? coreDataManager.context.fetch(fetchRequest)

        XCTAssertEqual(results?.count, 2, "There should be two items in Core Data.")
        XCTAssertEqual(results?.first?.name, "Test Item 1", "The first item's name should match.")
        XCTAssertEqual(results?.last?.name, "Test Item 2", "The second item's name should match.")
    }
}
