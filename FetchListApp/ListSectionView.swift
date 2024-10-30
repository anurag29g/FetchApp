//
//  ListSectionView.swift
//  FetchListApp
//
//  Created by Anurag Ghadge on 10/14/24.
//

import SwiftUI

struct ListSectionView: View {
    let listId: Int
    let items: [Item]
    @Binding var isExpanded: Bool   

    var body: some View {
        Section(header: Text("List ID: \(listId)").bold()) {
            DisclosureGroup(
                isExpanded: $isExpanded
            ) {
                ForEach(items) { item in
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
