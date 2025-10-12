//
//  CustomerListView.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 09/10/25.
//
import SwiftUI
import SwiftData
import Core

struct CustomerListView: View {
    @Environment(\.modelContext) private var context
    @Query private var customers: [Customer]
    
    init() {
        _customers = Query(
            FetchDescriptor<Customer>(
                sortBy: [SortDescriptor(\.name)]
            )
        )
    }
    
    @State private var showingAdd = false
    @State private var editingCustomer: Customer?
    
    var body: some View {
        List {
            if customers.isEmpty {
                emptyState
            } else {
                allCustomer
            }
        }
        .navigationTitle("Customers")
        .toolbar {
            addCustomer
        }
        .sheet(isPresented: $showingAdd) {
            CustomerFormView()
        }
        .sheet(item: $editingCustomer) { customer in
            CustomerFormView(customer: customer)
        }
    }
    
    private var addCustomer: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { showingAdd = true }) {
                Image(systemName: "plus")
            }
        }
    }
    
    private var allCustomer: some View {
        ForEach(customers) { customer in
            Button {
                editingCustomer = customer
            } label: {
                CustomerRow(customer: customer)
            }
            .buttonStyle(.plain)
        }
        .onDelete(perform: delete)
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.3")
                .font(.largeTitle)
                .foregroundColor(.gray)
            Text("No customers yet")
                .font(.headline)
                .foregroundColor(.secondary)
            Text("Tap + to add your first customer")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    private func delete(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                context.delete(customers[index])
            }
            do { try context.save() } catch { print("Delete error: \(error)") }
        }
    }
}

struct CustomerRow: View {
    let customer: Customer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(customer.name)
                    .font(.headline)
                Spacer()
                Text(customer.branch)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 16) {
                Label(customer.contactNumber, systemImage: "phone")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Label(customer.email, systemImage: "envelope")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if !customer.trnNumber.isEmpty {
                Label("TRN: \(customer.trnNumber)", systemImage: "number")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(customer.address)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Customer.self, configurations: config)
    for c in Customer.sampleData { container.mainContext.insert(c) }
    return NavigationStack { CustomerListView() }
        .modelContainer(container)
}
