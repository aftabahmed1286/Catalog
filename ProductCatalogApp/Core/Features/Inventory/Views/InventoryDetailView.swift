//
//  InventoryDetailView.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 07/10/25.
//

import SwiftUI
import SwiftData
import Core

struct InventoryDetailView: View {
    let product: Product
    @Environment(\.modelContext) private var modelContext
    @Query private var inventories: [Inventory]
    
    private var productInventories: [Inventory] {
        inventories.filter { $0.product?.id == product.id }
    }
    
    private var totalUnits: Int {
        productInventories.reduce(0) { $0 + $1.totalUnits }
    }
    
    var body: some View {
        List {
            // Product Header Section
            Section {
                HStack {
                    
                    productImage
                    
                    productDetail
                    
                    Spacer()
                }
                .padding(.vertical, 8)
            }
            
            // Inventory Entries Section
            Section("Inventory Entries") {
                if productInventories.isEmpty {
                    
                    productInventoriesEmpty
                    
                } else {
                    
                    productInventoriesExist
                    
                }
            }
        }
        .navigationTitle("Inventory Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var productImage: some View {
        VStack {
            if let imageData = product.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .font(.title2)
                    )
            }
        }
    }
    
    var productDetail: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(product.name)
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Barcode: \(product.barcode)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Price: $\(product.price, specifier: "%.2f")")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Text("Total Stock:")
                    .font(.headline)
                
                Text("\(totalUnits) units")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(totalUnits < 10 ? .red : .primary)
            }
        }
    }
    
    var productInventoriesExist: some View {
        ForEach(productInventories) { inventory in
            InventoryEntryRow(inventory: inventory)
        }
        .onDelete(perform: deleteInventory)
    }
    
    var productInventoriesEmpty: some View {
        HStack {
            Spacer()
            VStack(spacing: 8) {
                Image(systemName: "tray")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                
                Text("No inventory entries")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text("Go back and Tap + to add inventory")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 20)
            Spacer()
        }

    }
    
    private func deleteInventory(offsets: IndexSet) {
        withAnimation(.spring()) {
            for index in offsets {
                let inventory = productInventories[index]
                modelContext.delete(inventory)
            }
        }
    }
}

struct InventoryEntryRow: View {
    
    let inventory: Inventory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                
                cartonDetail
                
                Spacer()
                
                totalDetail
            }
            
            // Low stock warning
            lowStockWarning
        }
        .padding(.vertical, 4)
    }
    
    var cartonDetail: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(inventory.numberOfCartons) cartons")
                .font(.headline)
            
            Text("\(inventory.unitsPerCarton) units per carton")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    var totalDetail: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text("\(inventory.totalUnits) total units")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(inventory.totalUnits < 10 ? .red : .primary)
            
            Text("Updated: \(inventory.lastUpdated, style: .relative)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    var lowStockWarning: some View {
        VStack{
            if inventory.totalUnits < 10 {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .font(.caption)
                    
                    Text("Low stock alert")
                        .font(.caption)
                        .foregroundColor(.red)
                        .fontWeight(.medium)
                }
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
    
    return NavigationStack {
        InventoryDetailView(product: Product.sampleData[0])
    }
    .modelContainer(container)
}
