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

struct InventoryProductRow: View {
    let product: Product
    let inventories: [Inventory]
    
    private var totalStock: Int {
        inventories
            .filter { $0.product?.id == product.id }
            .reduce(0) { $0 + $1.totalUnits }
    }
    
    var body: some View {
        HStack {
            // Product Image
            productImage
            
            productDetail
            
            Spacer()
            
            stockAlert
        }
        .padding(.vertical, 4)
    }
    
    var productImage: some View {
        VStack {
            if let imageData = product.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
        }
    }
    
    var productDetail: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(product.name)
                .font(.headline)
                .lineLimit(1)
            
            Text("Barcode: \(product.barcode)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack {
                Text("Total Stock:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("\(totalStock) units")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(totalStock < 10 ? .red : .primary)
            }
        }
    }
    
    var stockAlert: some View {
        VStack {
            if totalStock < 10 {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                    .font(.title2)
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
