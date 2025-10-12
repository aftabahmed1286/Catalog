//
//  ReceiptDetailView.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 11/10/25.
//
import SwiftUI
import SwiftData
import Core

struct PaymentReceiptDetailView: View {
    
    let receipt: PaymentReceipt
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Receipt Header
                    receiptHeader
                    
                    Divider()
                    
                    // Customer Info
                    customerInfo
                    
                    Divider()
                    
                    // Paid Invoices
                    paidInvoices
                    
                    Divider()
                    
                    // Total Amount
                    totalAmount
                }
                .padding()
            }
            .navigationTitle("Receipt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                doneButton
            }
        }
    }
    
    var receiptHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Payment Receipt")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Receipt #: \(receipt.receiptNumber)")
                .font(.headline)
            
            Text("Date: \(receipt.paymentDate, style: .date)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    var customerInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let invoices = receipt.invoices,
               let firstInvoice = invoices.first,
               let customer = firstInvoice.customer {
                
                Text("Customer Details")
                    .font(.headline)
                
                Text(customer.name)
                    .font(.subheadline)
                
                Text(customer.email)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(customer.contactNumber)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    var paidInvoices: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Paid Invoices")
                .font(.headline)
            if let invoices = receipt.invoices {
                ForEach(invoices) { invoice in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(invoice.invoiceNumber)
                                .font(.subheadline)
                            Text("Date: \(invoice.invoiceDate, style: .date)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text("$\(invoice.totalAmount, specifier: "%.2f")")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
    
    var totalAmount: some View {
        HStack {
            Text("Total Paid:")
                .font(.headline)
            Spacer()
            Text("$\(receipt.totalAmount, specifier: "%.2f")")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
        }
    }
    
    var doneButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Done") { dismiss() }
        }
    }
    
    
}
