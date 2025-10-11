//
//  PaymentReceipt.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 09/10/25.
//
import SwiftUI
import SwiftData

@Model
class PaymentReceipt {
    var id: UUID = UUID()
    var receiptNumber: String = ""
    
    @Relationship(deleteRule: .nullify, inverse: \Invoice.paymentReceipt)
    var invoices: [Invoice]? = []
    
    var totalAmount: Double = 0.0
    var paymentDate: Date = Date.now
    var lastUpdated: Date = Date.now
    
    init(
        id: UUID = UUID(),
        receiptNumber: String = "",
        invoices: [Invoice]? = [],
        totalAmount: Double = 0.0,
        paymentDate: Date = Date.now,
        lastUpdated: Date = Date.now
    ) {
        self.id = id
        self.receiptNumber = receiptNumber
        self.invoices = invoices
        self.totalAmount = totalAmount
        self.paymentDate = paymentDate
        self.lastUpdated = lastUpdated
    }
}

extension PaymentReceipt {
    static var sampleData: [PaymentReceipt] = [
        PaymentReceipt(
            receiptNumber: "R1",
            totalAmount: 150.75,
            paymentDate: Date.now.addingTimeInterval(-86400)
        )
    ]
}

