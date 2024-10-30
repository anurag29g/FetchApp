//
//  ItemList.swift
//  FetchListApp
//
//  Created by Anurag Ghadge on 10/14/24.
//

import Foundation

struct Item: Codable, Identifiable {
    let id: Int
    let listId: Int
    let name: String?
}
