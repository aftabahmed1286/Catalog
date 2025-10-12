//
//  Dashboard.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 09/10/25.
//

import SwiftUI
import SwiftData

struct Dashboard: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var products: [Product]
    @Query private var inventories: [Inventory]
    @Query private var customers: [Customer]
    @Query private var invoices: [Invoice]
    
    @State private var viewModel: InventoryViewModel
    
    init() {
        
        _viewModel = State(wrappedValue: InventoryViewModel())
        
        _products = Query(FetchDescriptor<Product>(
            sortBy: [SortDescriptor(\.name)]
        ))
        
        _customers = Query(FetchDescriptor<Customer>(
            sortBy: [SortDescriptor(\.name)]
        ))
    }
    
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
                    goToCustomers
                    goToInvoices
                    goToPaymentReceipt
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Sample Data Button
//                Button("Load Sample Data") {
//                    loadSampleData()
//                }
//                .padding()
//                .background(Color.gray.opacity(0.2))
//                .cornerRadius(12)
//                .padding(.horizontal)
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
                value: "\(products.count)",
                icon: "cube.box",
                color: .blue
            )
            
            SummaryCard(
                title: "Customers",
                value: "\(customers.count)",
                icon: "person.3",
                color: .green
            )
            
            SummaryCard(
                title: "Invoices",
                value: "\(invoices.count)",
                icon: "doc.text",
                color: .orange
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
        return NavigationLink(destination: LowStockView(viewModel: viewModel)) {
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
    
    var goToCustomers: some View {
        NavigationLink(destination: CustomerListView()) {
            HStack {
                Image(systemName: "person.3.fill")
                Text("Manage Customers")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }
    
    var goToInvoices: some View {
        NavigationLink(destination: InvoicesView()) {
            HStack {
                Image(systemName: "doc.text.fill")
                Text("Manage Invoices")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.purple)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }
    
    var goToPaymentReceipt: some View {
        NavigationLink(destination: PaymentReceiptView()) {
            HStack {
                Image(systemName: "creditcard.fill")
                Text("Payment Receipt")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.indigo)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }
    
    private func loadSampleData() {
        // Clear existing data
        for inventory in inventories {
            modelContext.delete(inventory)
        }
        for invoice in invoices {
            modelContext.delete(invoice)
        }
        
        // Add sample inventory data
        for inventory in Inventory.sampleData {
            modelContext.insert(inventory)
        }
        
        // Add sample customer data
        for customer in Customer.sampleData {
            modelContext.insert(customer)
        }
        
        // Add sample invoice data
        for invoice in Invoice.sampleData {
            modelContext.insert(invoice)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save sample data: \(error)")
        }
    }
}

//struct SummaryCard: View {
//    let title: String
//    let value: String
//    let icon: String
//    let color: Color
//    
//    var body: some View {
//        VStack(spacing: 8) {
//            Image(systemName: icon)
//                .font(.title2)
//                .foregroundColor(color)
//            
//            Text(value)
//                .font(.title)
//                .fontWeight(.bold)
//            
//            Text(title)
//                .font(.caption)
//                .foregroundColor(.secondary)
//        }
//        .frame(maxWidth: .infinity)
//        .padding()
//        .background(color.opacity(0.1))
//        .cornerRadius(12)
//    }
//}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Product.self, Inventory.self, Customer.self, Invoice.self, LineItem.self, PaymentReceipt.self, configurations: config)
    
    // Add sample data
    let context = container.mainContext
    for product in Product.sampleData {
        context.insert(product)
    }
    for inventory in Inventory.sampleData {
        context.insert(inventory)
    }
    for customer in Customer.sampleData {
        context.insert(customer)
    }
    for invoice in Invoice.sampleData {
        context.insert(invoice)
    }
    
    return Dashboard()
        .modelContainer(container)
}

