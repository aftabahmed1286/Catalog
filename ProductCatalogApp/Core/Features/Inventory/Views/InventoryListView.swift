//
//  InventoryListView.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 07/10/25.
//

import SwiftUI
import SwiftData

struct InventoryListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var products: [Product]
    @Query private var inventories: [Inventory]
    
    @State private var showingAddInventory = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(products) { product in
                    NavigationLink(destination: InventoryDetailView(product: product)) {
                        InventoryProductRow(product: product, inventories: inventories)
                    }
                }
            }
            .navigationTitle("Inventory")
            .toolbar {
                addInventory
            }
            .sheet(isPresented: $showingAddInventory) {
                AddInventoryForProductView()
            }
        }
    }
    
    var addInventory: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                showingAddInventory = true
            }) {
                Image(systemName: "plus")
            }
        }
    }
}



#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Product.self, Inventory.self, configurations: config)
    
    // Add sample data
    let context = container.mainContext
    for product in Product.sampleData {
        context.insert(product)
    }
    for inventory in Inventory.sampleData {
        context.insert(inventory)
    }
    
    return InventoryListView()
        .modelContainer(container)
}
