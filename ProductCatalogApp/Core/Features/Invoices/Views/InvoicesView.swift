//
//  InvoiceListView.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 09/10/25.
//
import SwiftUI
import SwiftData

struct InvoicesView: View {
    @Environment(\.modelContext) private var context
    @Query private var invoices: [Invoice]
    
    @State private var viewModel = InvoicesViewModel()
    
    init() {
        _invoices = Query(
            FetchDescriptor<Invoice>(
                sortBy: [SortDescriptor(\.invoiceDate, order: .reverse)]
            )
        )
    }
    
    private var filteredInvoices: [Invoice] {
        if let status = viewModel.selectedStatus {
            return invoices.filter {
                $0.status == status
            }
        }
        return invoices
    }
    
    var body: some View {
        @Bindable var vm = viewModel
        NavigationStack {
            VStack {
                // Status Filter
                statusFilter
                
                // Invoices List
                if filteredInvoices.isEmpty {
                    emptyState
                } else {
                    invoicesList
                }
            }
            .navigationTitle("Invoices")
            .toolbar {
                addInvoiceButton
            }
            .sheet(isPresented: $vm.showingAddInvoice) {
                InvoiceFormView()
            }
            .sheet(item: $vm.editingInvoice) { invoice in
                InvoiceFormView(invoice: invoice)
            }
            .onAppear {
                vm.setModelContext(context)
            }
        }
    }
    
    private var statusFilter: some View {
        @Bindable var vm = viewModel
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                Button(action: { vm.selectedStatus = nil }) {
                    Text("All")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(vm.selectedStatus == nil ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundColor(vm.selectedStatus == nil ? .white : .primary)
                        .cornerRadius(20)
                }
                
                ForEach(InvoiceStatus.allCases, id: \.self) { status in
                    Button(action: { vm.selectedStatus = status }) {
                        Text(status.rawValue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(vm.selectedStatus == status ? status.color : Color.gray.opacity(0.2))
                            .foregroundColor(vm.selectedStatus == status ? .white : .primary)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
    
    private var invoicesList: some View {
        @Bindable var vm = viewModel
        return List {
            ForEach(filteredInvoices) { invoice in
                Button(action: { vm.editingInvoice = invoice }) {
                    InvoiceRow(invoice: invoice)
                }
                .buttonStyle(.plain)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button("Delete", role: .destructive) {
                        deleteInvoice(invoice)
                    }
                }
            }
        }
    }
    
    private var emptyState: some View {
        @Bindable var vm = viewModel
        return VStack(spacing: 16) {
            Image(systemName: "doc.text")
                .font(.largeTitle)
                .foregroundColor(.gray)
            
            Text("No invoices found")
                .font(.headline)
                .foregroundColor(.secondary)
            
            if vm.selectedStatus != nil {
                Text("Try changing the filter")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                Text("Tap + to create your first invoice")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    private var addInvoiceButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { viewModel.showingAddInvoice = true }) {
                Image(systemName: "plus")
            }
        }
    }
    
    private func deleteInvoice(_ invoice: Invoice) {
        withAnimation {
            do {
                try viewModel.deleteInvoice(invoice)
            } catch {
                print("Failed to delete invoice: \(error)")
            }
        }
    }
    
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Invoice.self, LineItem.self, Customer.self, Product.self, configurations: config)

    // Add sample data
    let context = container.mainContext
    for customer in Customer.sampleData {
        context.insert(customer)
    }
    for product in Product.sampleData {
        context.insert(product)
    }
    
    for invoice in Invoice.sampleData {
        context.insert(invoice)
    }
    
    return InvoicesView()
        .modelContainer(container)
}

