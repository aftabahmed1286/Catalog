//
//  InvoiceViewModel.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 09/10/25.
//
import SwiftUI
import SwiftData

@Observable
class InvoicesViewModel {
    private var modelContext: ModelContext?
    
    var showingAddInvoice = false
    var editingInvoice: Invoice?
    var selectedStatus: InvoiceStatus? = nil
    
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    // MARK: - Invoice Management
    
//    func deleteInvoice(_ invoice: Invoice) throws {
//        guard let context = modelContext else { throw InvoiceError.noModelContext }
//        
//        // Delete associated line items
//        for lineItem in invoice.lineItems {
//            context.delete(lineItem)
//        }
//        
//        context.delete(invoice)
//        try context.save()
//    }
    
    func updateInvoiceStatus(_ invoice: Invoice, status: InvoiceStatus) throws {
        guard let context = modelContext else { throw InvoiceError.noModelContext }
        
//        invoice.status = status
        invoice.lastUpdated = Date.now
        
        try context.save()
    }
    
    // MARK: - Line Item Management
    
    
    
    func updateLineItem(_ lineItem: LineItem, quantity: Int, price: Double, vatPercentage: Double) throws {
        guard let context = modelContext else { throw InvoiceError.noModelContext }
        
        lineItem.quantity = quantity
        lineItem.price = price
        lineItem.vatPercentage = vatPercentage
        lineItem.lastUpdated = Date.now
        
        try context.save()
    }
    
    func deleteLineItem(_ lineItem: LineItem) throws {
        guard let context = modelContext else { throw InvoiceError.noModelContext }
        
        context.delete(lineItem)
        try context.save()
    }
    
    // MARK: - Payment Receipt Management
    
    
    
    
    
    // MARK: - Analytics
    
    
    func getInvoicesByStatus(_ status: InvoiceStatus, in invoices: [Invoice]) -> [Invoice] {
        invoices.filter { $0.status == status }
    }
    
    func getInvoicesForCustomer(_ customer: Customer, in invoices: [Invoice]) -> [Invoice] {
        invoices.filter { $0.customer?.id == customer.id }
    }
}

enum InvoiceError: LocalizedError {
    case noModelContext
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .noModelContext:
            return "Model context is not available"
        case .invalidData:
            return "Invalid invoice data provided"
        }
    }
}

