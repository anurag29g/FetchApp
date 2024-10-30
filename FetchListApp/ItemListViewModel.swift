//
//  ItemListViewModel.swift
//  FetchListApp
//
//  Created by Anurag Ghadge on 10/14/24.
//

import Foundation
import CoreData

class ItemViewModel: ObservableObject {
    @Published var groupedItems: [Int: [Item]] = [:]
    @Published var isLoading: Bool = false
    @Published var hasDataLoaded: Bool = false

    private let coreDataManager = CoreDataManager.shared

    func fetchItems(forceRefresh: Bool = false) {
        if !forceRefresh && hasDataLoaded {
            print("Data already loaded. Skipping fetch.")
            return
        }

        print("Fetching items...")
        isLoading = true

        URLSession.shared.dataTask(with: URL(string: "https://fetch-hiring.s3.amazonaws.com/hiring.json")!) { data, _, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    print("Network error: \(error.localizedDescription)")
                    self.loadItemsFromCoreData()
                    return
                }

                if let data = data {
                    print("Data fetched successfully!")
                    self.saveItemsToCoreData(data: data)
                }

                self.loadItemsFromCoreData()
            }
        }.resume()
    }
    
    private func saveItemsToCoreData(data: Data) {
        coreDataManager.clearData()

        do {
            let items = try JSONDecoder().decode([Item].self, from: data)
                .filter { $0.name?.isEmpty == false }

            for item in items {
                let cachedItem = CachedItem(context: coreDataManager.context)
                cachedItem.id = Int64(item.id)
                cachedItem.listId = Int64(item.listId)
                cachedItem.name = item.name
            }
            coreDataManager.saveContext()
            print("Items saved to Core Data.")
        } catch {
            print("Error saving to Core Data: \(error)")
        }
    }

    private func loadItemsFromCoreData() {
        let request: NSFetchRequest<CachedItem> = CachedItem.fetchRequest()
        do {
            let results = try coreDataManager.context.fetch(request)
            let items = results.map { Item(id: Int($0.id), listId: Int($0.listId), name: $0.name) }
 
            let sortedGroupedItems = Dictionary(grouping: items, by: { $0.listId }).mapValues { $0.sorted { $0.id < $1.id } }

            DispatchQueue.main.async {
                self.groupedItems = sortedGroupedItems
                self.hasDataLoaded = true
                print("Grouped Items: \(self.groupedItems)")
            }
        } catch {
            print("Failed to fetch items from Core Data: \(error)")
        }
    }
}
