//
//  ContentView.swift
//  FetchListApp
//
//  Created by Anurag Ghadge on 10/14/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ItemViewModel()
    @State private var expandedSections: [Int: Bool] = [:]
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search items...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                ZStack {
                    if viewModel.isLoading {
                        ProgressView("Loading...")
                            .scaleEffect(1.5)
                            .padding()
                    } else {
                        List {
                            ForEach(filteredGroupedItems().keys.sorted(), id: \.self) { listId in
                                Section(header: Text("List ID: \(listId)").bold()) {
                                    DisclosureGroup(
                                        isExpanded: Binding(
                                            get: { expandedSections[listId] ?? true },
                                            set: { expandedSections[listId] = $0 }
                                        )
                                    ) {
                                        ForEach(filteredGroupedItems()[listId] ?? []) { item in
                                            HStack {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.green)
                                                Text(item.name ?? "Unnamed Item")
                                                    .padding(.vertical, 5)
                                            }
                                        }
                                    } label: {
                                        Text("List ID \(listId)")
                                    }
                                }
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                        .refreshable {
                            viewModel.fetchItems(forceRefresh: true)
                        }
                        .onAppear {
                            initializeExpandedSections()
                            viewModel.fetchItems(forceRefresh: false)
                        }
                    }
                }
            }
            .navigationTitle("Fetch List")
        }
    }

    private func filteredGroupedItems() -> [Int: [Item]] {
        if searchText.isEmpty {
            return viewModel.groupedItems
        } else {
            let filteredItems = viewModel.groupedItems
                .flatMap { $0.value }
                .filter { $0.name?.lowercased().contains(searchText.lowercased()) ?? false }
            return Dictionary(grouping: filteredItems, by: { $0.listId })
        }
    }

    private func initializeExpandedSections() {
        for key in viewModel.groupedItems.keys {
            expandedSections[key] = true
        }
    }
}

#Preview {
    ContentView()
}
