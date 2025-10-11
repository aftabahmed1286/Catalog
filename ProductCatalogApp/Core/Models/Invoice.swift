//
//  Invoice.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 09/10/25.
//
import SwiftUI
import SwiftData

@Model
class Invoice {
    var id: UUID = UUID()
    var invoiceNumber: String = ""
    var invoiceDate: Date = Date.now
    var deliveredDate: Date?
    
    var customer: Customer?
    
    @Relationship(deleteRule: .nullify, inverse: \LineItem.invoice)
    var lineItems: [LineItem]? = []
    
    var paymentReceipt: PaymentReceipt?
    
    var lastUpdated: Date = Date.now
    
    // Computed properties
    var subTotal: Double {
        lineItems?.reduce(0) { $0 + ($1.price * Double($1.quantity)) } ?? 0
    }
    
    var totalVAT: Double {
        lineItems?.reduce(0) { $0 + $1.vatAmount } ?? 0
    }
    
    var totalAmount: Double {
        subTotal + totalVAT
    }
    
    var status: InvoiceStatus {
        if paymentReceipt != nil {
            return .paid
        }
        if let deliveredDate, Date.now > deliveredDate {
            return .overdue
        }
        return .draft
    }
    
    init(
        id: UUID = UUID(),
        invoiceNumber: String = "",
        invoiceDate: Date = Date.now,
        deliveredDate: Date? = nil,
        customer: Customer? = nil,
        lineItems: [LineItem] = [],
        paymentReceipt: PaymentReceipt? = nil,
        lastUpdated: Date = Date.now
    ) {
        self.id = id
        self.invoiceNumber = invoiceNumber
        self.invoiceDate = invoiceDate
        self.deliveredDate = deliveredDate
        self.customer = customer
        self.lineItems = lineItems
        self.paymentReceipt = paymentReceipt
        self.lastUpdated = lastUpdated
    }
}

enum InvoiceStatus: String, CaseIterable, Codable {
    case draft = "Draft"
    case overdue = "Overdue"
    case paid = "Paid"
    
    var color: Color {
        switch self {
        case .draft: return .orange
        case .overdue: return .red
        case .paid: return .green
        }
    }
}

extension Invoice {
    static var sampleData: [Invoice] = [
        Invoice(
            invoiceNumber: "T1",
            invoiceDate: Date.now,
            deliveredDate: nil
        ),
        Invoice(
            invoiceNumber: "T2",
            invoiceDate: Date.now.addingTimeInterval(-86400),
            deliveredDate: Date.now.addingTimeInterval(-3600) // overdue: delivered 1 hour ago
        ),
        Invoice(
            invoiceNumber: "T3",
            invoiceDate: Date.now.addingTimeInterval(-172800),
            deliveredDate: Date.now.addingTimeInterval(-86400),
            paymentReceipt: PaymentReceipt() // assuming default init for demonstration
        )
    ]
}
