//
//  InvoiceFormView.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 09/10/25.
//
import SwiftUI
import SwiftData

struct InvoiceFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var customers: [Customer]
    @Query private var products: [Product]
    
    @State private var viewModel = InvoiceFormViewModel()
    
    init(invoice: Invoice? = nil) {
        self.viewModel.invoice = invoice
    }
    
    var body: some View {
        @Bindable var vm = viewModel
        NavigationStack {
            Form {
                // Customer Section
                Section("Customer") {
                    customerPicker
                    if let customer = vm.selectedCustomer {
                        customerDetails(customer)
                    }
                }
                
                // Line Items Section
                Section("Line Items") {
                    lineItemsList
                    addLineItemButton
                }
                
                // Invoice Summary
                if !vm.lineItems.isEmpty {
                    Section("Invoice Summary") {
                        invoiceSummary
                    }
                }
            }
            .navigationTitle(vm.invoice == nil ? "Create Invoice" : "Edit Invoice")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveInvoice() }
                        .disabled(vm.selectedCustomer == nil || vm.lineItems.isEmpty)
                }
            }
            .onAppear {
                vm.setModelContext(modelContext)
                if let invoice = vm.invoice {
                    vm.selectedCustomer = invoice.customer
                    vm.lineItems = invoice.lineItems ?? []
                }
            }
        }
    }
    
    private var customerPicker: some View {
        @Bindable var vm = viewModel
        return Picker("Select Customer", selection: $vm.selectedCustomer) {
            Text("Choose a customer")
                .tag(nil as Customer?)
            
            ForEach(customers) { customer in
                HStack {
                    Text(customer.name)
                    Spacer()
                    Text(customer.branch)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .tag(customer as Customer?)
            }
        }
    }
    
    private func customerDetails(_ customer: Customer) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Bill To:")
                    .font(.headline)
                Spacer()
                Text("Ship To:")
                    .font(.headline)
            }
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(customer.name)
                        .font(.subheadline)
                    Text(customer.email)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(customer.contactNumber)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(customer.address)
                        .font(.subheadline)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private var lineItemsList: some View {
        @Bindable var vm = viewModel
        return ForEach(vm.lineItems) { lineItem in
            LineItemRow(
                lineItem: lineItem,
                onUpdate: { updatedLineItem in
                    if let index = vm.lineItems.firstIndex(where: { $0.id == updatedLineItem.id }) {
                        vm.lineItems[index] = updatedLineItem
                    }
                },
                onDelete: {
                    vm.lineItems.removeAll { $0.id == lineItem.id }
                }
            )
        }
    }
    
    private var addLineItemButton: some View {
        @Bindable var vm = viewModel
        return Button(action: { vm.showingProductPicker = true }) {
            HStack {
                Image(systemName: "plus.circle")
                Text("Add Line Item")
            }
        }
        .sheet(isPresented: $vm.showingProductPicker) {
            ProductPickerView(
                products: products,
                onProductSelected: { product in
                    let lineItem = vm.createLineItem(
                        product: product,
                        quantity: 1,
                        price: product.price,
                        vatPercentage: 15.0
                    )
                    vm.lineItems.append(lineItem)
                }
            )
        }
    }
    
    private var invoiceSummary: some View {
        @Bindable var vm = viewModel
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Sub Total:")
                Spacer()
                Text("$\(vm.lineItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }, specifier: "%.2f")")
            }
            
            HStack {
                Text("VAT:")
                Spacer()
                Text("$\(vm.lineItems.reduce(0) { $0 + $1.vatAmount }, specifier: "%.2f")")
            }
            
            Divider()
            
            HStack {
                Text("Total:")
                    .font(.headline)
                Spacer()
                Text("$\(vm.lineItems.reduce(0) { $0 + $1.amount }, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func saveInvoice() {
        @Bindable var vm = viewModel
        do {
            if let invoice = vm.invoice {
                try vm.updateInvoice(
                    invoice,
                    customer: vm.selectedCustomer,
                    lineItems: vm.lineItems,
                    status: invoice.status
                )
            } else {
                try vm.createInvoice(
                    customer: vm.selectedCustomer,
                    lineItems: vm.lineItems
                )
            }
            dismiss()
        } catch {
            print("Failed to save invoice: \(error)")
        }
    }
}

struct LineItemRow: View {
    let lineItem: LineItem
    let onUpdate: (LineItem) -> Void
    let onDelete: () -> Void
    
    @State private var quantity: Int
    @State private var price: Double
    @State private var vatPercentage: Double
    
    init(lineItem: LineItem, onUpdate: @escaping (LineItem) -> Void, onDelete: @escaping () -> Void) {
        self.lineItem = lineItem
        self.onUpdate = onUpdate
        self.onDelete = onDelete
        self._quantity = State(initialValue: lineItem.quantity)
        self._price = State(initialValue: lineItem.price)
        self._vatPercentage = State(initialValue: lineItem.vatPercentage)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(lineItem.name)
                        .font(.headline)
                    Text("Barcode: \(lineItem.barcode)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Quantity")
                        .font(.caption)
                    Stepper("", value: $quantity, in: 1...999)
                        .onChange(of: quantity) { _, newValue in
                            updateLineItem()
                        }
                }
                
                VStack(alignment: .leading) {
                    Text("Price")
                        .font(.caption)
                    TextField("Price", value: $price, format: .currency(code: "USD"))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: price) { _, newValue in
                            updateLineItem()
                        }
                }
                
                VStack(alignment: .leading) {
                    Text("VAT %")
                        .font(.caption)
                    TextField("VAT %", value: $vatPercentage, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: vatPercentage) { _, newValue in
                            updateLineItem()
                        }
                }
            }
            
            HStack {
                Text("Amount: $\(lineItem.amount, specifier: "%.2f")")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("VAT: $\(lineItem.vatAmount, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func updateLineItem() {
        lineItem.quantity = quantity
        lineItem.price = price
        lineItem.vatPercentage = vatPercentage
        onUpdate(lineItem)
    }
}

struct ProductPickerView: View {
    let products: [Product]
    let onProductSelected: (Product) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List(products) { product in
                Button(action: {
                    onProductSelected(product)
                    dismiss()
                }) {
                    HStack {
                        if let imageData = product.imageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray)
                                )
                        }
                        
                        VStack(alignment: .leading) {
                            Text(product.name)
                                .font(.headline)
                            Text("Barcode: \(product.barcode)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("$\(product.price, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        
                        Spacer()
                    }
                }
                .buttonStyle(.plain)
            }
            .navigationTitle("Select Product")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") { dismiss() }
                }
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
    
    return InvoiceFormView()
        .modelContainer(container)
}

