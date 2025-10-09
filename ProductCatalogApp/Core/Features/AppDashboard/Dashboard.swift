//
//  InventoryTestView.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 07/10/25.
//

import SwiftUI
import SwiftData

struct Dashboard: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var products: [Product]
    @Query private var inventories: [Inventory]
    
    @State private var viewModel = InventoryViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Header
                dashboardTitle
                
                // Summary Cards
                summaryCards
                
                // Navigation Buttons
                VStack(spacing: 12) {
                    
                    goToCatalog
                    
                    goToInventory
                    
                    goToLowStock
                    
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Sample Data Button
                Button("Load Sample Data") {
                    loadSampleData()
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .onAppear {
                viewModel.setModelContext(modelContext)
            }
        }
    }
    
    var dashboardTitle: some View {
        VStack(spacing: 8) {
            Text("Dashboard")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .padding()
    }
    
    var summaryCards: some View {
        HStack(spacing: 16) {
            let summary = viewModel.getInventorySummary(in: inventories)
            
            SummaryCard(
                title: "Products",
                value: "\(summary.totalProducts)",
                icon: "cube.box",
                color: .blue
            )
            
            SummaryCard(
                title: "Total Units",
                value: "\(summary.totalUnits)",
                icon: "number",
                color: .green
            )
            
            SummaryCard(
                title: "Low Stock",
                value: "\(summary.lowStockCount)",
                icon: "exclamationmark.triangle",
                color: summary.lowStockCount > 0 ? .red : .gray
            )
        }
        .padding(.horizontal)
    }
    
    var goToCatalog: some View {
        NavigationLink(destination: Catalog()) {
            HStack {
                Image(systemName: "cube.box.fill")
                Text("View All Products")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }
    
    var goToInventory: some View {
        NavigationLink(destination: InventoryListView()) {
            HStack {
                Image(systemName: "tray.full")
                Text("View All Inventory")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }
    
    var goToLowStock: some View {
        let summary = viewModel.getInventorySummary(in: inventories)
        return NavigationLink(destination: LowStockView()) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                Text("Low Stock Alert")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(summary.lowStockCount > 0 ? Color.red : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(summary.lowStockCount == 0)
    }
    
    
    
    private func loadSampleData() {
        // Clear existing data
        for inventory in inventories {
            modelContext.delete(inventory)
        }
        
        // Add sample inventory data
        for inventory in Inventory.sampleData {
            modelContext.insert(inventory)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save sample data: \(error)")
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
    
    return Dashboard()
        .modelContainer(container)
}
