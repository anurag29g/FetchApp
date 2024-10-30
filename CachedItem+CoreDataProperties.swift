//
//  CachedItem+CoreDataProperties.swift
//  FetchListApp
//
//  Created by Anurag Ghadge on 10/14/24.
//
//

import Foundation
import CoreData


extension CachedItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedItem> {
        return NSFetchRequest<CachedItem>(entityName: "CachedItem")
    }

    @NSManaged public var id: Int64
    @NSManaged public var listId: Int64
    @NSManaged public var name: String?

}

extension CachedItem : Identifiable {

}
