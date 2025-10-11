//
//  InvoiceRow.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 11/10/25.
//
import SwiftUI

struct InvoiceRow: View {
    
    let invoice: Invoice
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                
                invoicInfo
                
                Spacer()
                
                invoiceAmountStatus
            }
            
            invoiceDateLineItemCount
            
            invoiceLineItems
        }
        .padding(.vertical, 8)
    }
    
    private var invoicInfo: some View {
        VStack(alignment: .leading) {
            Text(invoice.invoiceNumber)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(invoice.customer?.name ?? "No Customer")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var invoiceAmountStatus: some View {
        VStack(alignment: .trailing) {
            Text("$\(invoice.totalAmount, specifier: "%.2f")")
                .font(.headline)
                .foregroundColor(.blue)
            
            Text(invoice.status.rawValue)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(invoice.status.color.opacity(0.2))
                .foregroundColor(invoice.status.color)
                .cornerRadius(8)
        }
    }
    
    private var invoiceDateLineItemCount: some View {
        HStack {
            Text("Date: \(invoice.invoiceDate, style: .date)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text("Items: \(invoice.lineItems?.count ?? 0)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private var invoiceLineItems: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let lineItems = invoice.lineItems, !lineItems.isEmpty {
                Text("Line Items:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                ForEach(lineItems.prefix(2)) { item in
                    HStack {
                        Text("• \(item.name)")
                            .font(.caption)
                        Spacer()
                        Text("Qty: \(item.quantity)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                if let lineItems = invoice.lineItems, lineItems.count > 2 {
                    let remainingItemCount = lineItems.count - 2
                    Text("+ \(remainingItemCount) more item(s)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    
}

#Preview {
    InvoiceRow(invoice: Invoice.sampleData[1])
}
