//
//  InvoiceSelectionRow.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 11/10/25.
//
import SwiftUI
import SwiftData

struct PaymentReceiptInvoiceSelectionRow: View {
    
    let invoice: Invoice
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack {
                
                invoiceInfo
                
                Spacer()
                
                invoiceAmountStatus
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
    
    var invoiceInfo: some View {
        HStack{
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? .blue : .gray)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(invoice.invoiceNumber)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Date: \(invoice.invoiceDate, style: .date)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Items: \(invoice.lineItems?.count ?? 0)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    var invoiceAmountStatus: some View {
        VStack(alignment: .trailing) {
            Text("$\(invoice.totalAmount, specifier: "%.2f")")
                .font(.headline)
                .foregroundColor(.blue)
            
            Text(invoice.status.rawValue)
                .font(.caption)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(invoice.status.color.opacity(0.2))
                .foregroundColor(invoice.status.color)
                .cornerRadius(4)
        }
    }
    
    
}
