//
//  LineItemRow.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 11/10/25.
//
import SwiftUI
import SwiftData


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
            nameBarCode
            qtyPriceVat
            amount
        }
        .padding(.vertical, 4)
    }
    
    private var nameBarCode: some View {
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
                    .padding(8)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())
            }
            .buttonStyle(PlainButtonStyle())
            .contentShape(Circle())
        }
    }
    
    private var qtyPriceVat: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Quantity")
                    .font(.caption)
                
                TextField("Quantity", value: $quantity, format: .number)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: quantity) { _, newValue in
                        if newValue < 1 {
                            quantity = 1
                        }
                        updateLineItem()
                    }
                
            }
            
            VStack(alignment: .leading) {
                Text("Price")
                    .font(.caption)
                TextField("Price", value: $price, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: price) { _, newValue in
                        updateLineItem()
                    }
            }
            
            VStack(alignment: .leading) {
                Text("VAT %")
                    .font(.caption)
                TextField("VAT %", value: $vatPercentage, format: .number)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: vatPercentage) { _, newValue in
                        updateLineItem()
                    }
            }
        }
    }
    
    private var amount: some View {
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
    
    private func updateLineItem() {
        lineItem.quantity = quantity
        lineItem.price = price
        lineItem.vatPercentage = vatPercentage
        onUpdate(lineItem)
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
