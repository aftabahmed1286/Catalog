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
    
    func deleteInvoice(_ invoice: Invoice) throws {
        guard let context = modelContext else { throw InvoiceError.noModelContext }
        context.delete(invoice)
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

