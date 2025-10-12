//
//  PaymentReceiptViewModel.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 11/10/25.
//
import SwiftUI
import SwiftData
import Core

@Observable
class PaymentReceiptViewModel {
    
    private var modelContext: ModelContext?
    
    var selectedCustomer: Customer?
    var selectedInvoices: Set<Invoice> = []
    var showingReceipt = false
    var generatedReceipt: PaymentReceipt?
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func customerInvoices(_ invoices: [Invoice]) -> [Invoice] {
        guard let customer = selectedCustomer else { return [] }
        return invoices.filter {
            $0.customer?.id == customer.id && $0.status != .paid
        }
    }
    
    func totalAmount() -> Double {
        selectedInvoices.reduce(0) { $0 + $1.totalAmount }
    }
    
    func getOutstandingAmount(for customer: Customer, in invoices: [Invoice]) -> Double {
        invoices
            .filter { $0.customer?.id == customer.id && $0.status != .paid }
            .reduce(0) { $0 + $1.totalAmount }
    }
    
    // MARK: - Payment Receipt Management
    func generateReceipt() {
        guard let customer = selectedCustomer else { return }
        
        do {
            let receipt = try createPaymentReceipt(
                customer: customer,
                paidInvoices: Array(selectedInvoices)
            )
            generatedReceipt = receipt
            showingReceipt = true
            
            // Clear selections
            selectedInvoices.removeAll()
            selectedCustomer = nil
        } catch {
            print("Failed to generate receipt: \(error)")
        }
    }
    
    
    func createPaymentReceipt(customer: Customer, paidInvoices: [Invoice]) throws -> PaymentReceipt {
        guard let context = modelContext else { throw InvoiceError.noModelContext }
        
        let totalAmount = paidInvoices.reduce(0) { $0 + $1.totalAmount }
        let receiptNumber = generateReceiptNumber()
        
        let receipt = PaymentReceipt(
            receiptNumber: receiptNumber,
            invoices: paidInvoices,
            totalAmount: totalAmount,
            paymentDate: Date.now,
            lastUpdated: Date.now
        )
        
        // Update invoice statuses to paid
        for invoice in paidInvoices {
            invoice.lastUpdated = Date.now
        }
        
        context.insert(receipt)
        try context.save()
        
        return receipt
    }
    
    private func generateReceiptNumber() -> String {
        guard let context = modelContext else { return "R1" }
        
        let request = FetchDescriptor<PaymentReceipt>(
            sortBy: [SortDescriptor(\.receiptNumber, order: .reverse)]
        )
        
        do {
            let receipts = try context.fetch(request)
            if let lastReceipt = receipts.first,
               let lastNumber = Int(lastReceipt.receiptNumber.dropFirst()) {
                return "R\(lastNumber + 1)"
            }
        } catch {
            print("Error fetching receipts: \(error)")
        }
        
        return "R1"
    }
    
    
    
}
