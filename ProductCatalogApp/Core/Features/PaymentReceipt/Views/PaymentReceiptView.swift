//
//  PaymentReceiptView.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 09/10/25.
//
import SwiftUI
import SwiftData

struct PaymentReceiptView: View {
    @Environment(\.modelContext) private var context
    @Query private var customers: [Customer]
    @Query private var invoices: [Invoice]
    
    @State private var viewModel: PaymentReceiptViewModel
    
    init() {
        _invoices = Query(
            FetchDescriptor<Invoice>(
                sortBy: [SortDescriptor(\.invoiceDate)]
            )
        )
        
        _customers = Query(FetchDescriptor<Customer>(
            sortBy: [SortDescriptor(\.name)]
        ))
        
        _viewModel = State(wrappedValue: PaymentReceiptViewModel())
    }
    
    private var customerInvoices: [Invoice] {
        viewModel.customerInvoices(invoices)
    }
    
    private var totalAmount: Double {
        viewModel.totalAmount()
    }
    
    var body: some View {
        @Bindable var vm = viewModel
        NavigationStack {
            VStack(spacing: 20) {
                // Customer Selection
                customerSelection
                
                if let customer = vm.selectedCustomer {
                    // Outstanding Amount
                    outstandingAmountCard(customer)
                    
                    // Invoice Selection
                    invoiceSelection
                    
                    // Payment Summary
                    if !vm.selectedInvoices.isEmpty {
                        paymentSummary
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Payment Receipt")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Generate Receipt") {
                        generateReceipt()
                    }
                    .disabled(vm.selectedCustomer == nil || vm.selectedInvoices.isEmpty)
                }
            }
            .sheet(isPresented: $vm.showingReceipt) {
                if let receipt = vm.generatedReceipt {
                    PaymentReceiptDetailView(receipt: receipt)
                }
            }
            .onAppear {
                vm.setModelContext(context)
            }
        }
    }
    
    private var customerSelection: some View {
        @Bindable var vm = viewModel
        return VStack(alignment: .leading, spacing: 8) {
            Text("Select Customer")
                .font(.headline)
            
            Picker("Customer", selection: $vm.selectedCustomer) {
                Text("Choose a customer")
                    .tag(nil as Customer?)
                
                ForEach(customers) { customer in
                    HStack {
                        Text(customer.name)
                        Spacer()
                        Text("$\(vm.getOutstandingAmount(for: customer, in: invoices), specifier: "%.2f")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .tag(customer as Customer?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .onChange(of: vm.selectedCustomer) { _, newCustomer in
                vm.selectedInvoices.removeAll()
            }
        }
    }
    
    private func outstandingAmountCard(_ customer: Customer) -> some View {
        @Bindable var vm = viewModel
        let outstanding = vm.getOutstandingAmount(for: customer, in: invoices)
        
        return VStack(spacing: 8) {
            HStack {
                Text("Outstanding Amount")
                    .font(.headline)
                Spacer()
                Text("$\(outstanding, specifier: "%.2f")")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(outstanding > 0 ? .red : .green)
            }
            
            if outstanding == 0 {
                Text("No outstanding invoices")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var invoiceSelection: some View {
        @Bindable var vm = viewModel
        return VStack(alignment: .leading, spacing: 12) {
            Text("Select Invoices to Pay")
                .font(.headline)
            
            if customerInvoices.isEmpty {
                Text("No outstanding invoices for this customer")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            } else {
                ForEach(customerInvoices) { invoice in
                    PaymentReceiptInvoiceSelectionRow(
                        invoice: invoice,
                        isSelected: vm.selectedInvoices.contains(invoice),
                        onToggle: { toggleInvoice(invoice) }
                    )
                }
            }
        }
    }
    
    private var paymentSummary: some View {
        @Bindable var vm = viewModel
        return VStack(spacing: 8) {
            HStack {
                Text("Payment Summary")
                    .font(.headline)
                Spacer()
            }
            
            HStack {
                Text("Selected Invoices: \(vm.selectedInvoices.count)")
                    .font(.subheadline)
                Spacer()
                Text("$\(totalAmount, specifier: "%.2f")")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func toggleInvoice(_ invoice: Invoice) {
        @Bindable var vm = viewModel
        if vm.selectedInvoices.contains(invoice) {
            vm.selectedInvoices.remove(invoice)
        } else {
            vm.selectedInvoices.insert(invoice)
        }
    }
    
    private func generateReceipt() {
        viewModel.generateReceipt()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Invoice.self, LineItem.self, Customer.self, Product.self, PaymentReceipt.self, configurations: config)
    
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
    
    return PaymentReceiptView()
        .modelContainer(container)
}

