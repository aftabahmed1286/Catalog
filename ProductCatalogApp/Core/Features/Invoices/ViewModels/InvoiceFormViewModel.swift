//
//  InvoiceFormViewModel.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 10/10/25.
//
import SwiftUI
import SwiftData

@Observable
class InvoiceFormViewModel {
    
    private var modelContext: ModelContext?
    
    var invoice: Invoice? = nil
    
    var selectedCustomer: Customer?
    var lineItems: [LineItem] = []
    var showingProductPicker = false
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func createLineItem(product: Product, quantity: Int, price: Double, vatPercentage: Double) -> LineItem {
        return LineItem(
            product: product,
            quantity: quantity,
            price: price,
            vatPercentage: vatPercentage,
            lastUpdated: Date.now
        )
    }
    
    func createInvoice(customer: Customer?, lineItems: [LineItem]) throws {
        guard let context = modelContext else { throw InvoiceError.noModelContext }
        
        let invoice = Invoice(
            invoiceNumber: generateInvoiceNumber(),
            invoiceDate: Date.now,
            customer: customer,
            lineItems: lineItems,
            //status: InvoiceStatus.draft,
            lastUpdated: Date.now
        )
        
        context.insert(invoice)
        try context.save()
    }
    
    func generateInvoiceNumber() -> String {
        guard let context = modelContext else { return "T1" }
        
        let request = FetchDescriptor<Invoice>(
            sortBy: [SortDescriptor(\.invoiceNumber, order: .reverse)]
        )
        
        do {
            let invoices = try context.fetch(request)
            if let lastInvoice = invoices.first,
               let lastNumber = Int(lastInvoice.invoiceNumber.dropFirst()) {
                return "T\(lastNumber + 1)"
            }
        } catch {
            print("Error fetching invoices: \(error)")
        }
        
        return "T1"
    }
    
    
    func updateInvoice(_ invoice: Invoice, customer: Customer?, lineItems: [LineItem], status: InvoiceStatus) throws {
        guard let context = modelContext else { throw InvoiceError.noModelContext }
        
        invoice.customer = customer
        invoice.lineItems = lineItems
//        invoice.status = status
        invoice.lastUpdated = Date.now
        
        try context.save()
    }
}
