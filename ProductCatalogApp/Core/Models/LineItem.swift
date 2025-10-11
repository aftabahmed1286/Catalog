//
//  LineItem.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 09/10/25.
//
import SwiftUI
import SwiftData

@Model
class LineItem {
    var id: UUID = UUID()
    
    var invoice: Invoice?
    
    var name: String = ""
    var barcode: String = ""
    var quantity: Int = 1
    var price: Double = 0.0
    var vatPercentage: Double = 0.0
    var lastUpdated: Date = Date.now
    
    // Computed properties
    var vatAmount: Double {
        (price * Double(quantity) * vatPercentage) / 100.0
    }
    
    var amount: Double {
        (price * Double(quantity)) + vatAmount
    }
    
    init(
        id: UUID = UUID(),
        product: Product? = nil,
        quantity: Int = 1,
        price: Double = 0.0,
        vatPercentage: Double = 0.0,
        lastUpdated: Date = Date.now
    ) {
        self.id = id
        self.name = product?.name ?? ""
        self.barcode = product?.barcode ?? ""
        self.quantity = quantity
        self.price = price
        self.vatPercentage = vatPercentage
        self.lastUpdated = lastUpdated
    }
}

extension LineItem {
    static var sampleData: [LineItem] = [
        LineItem(
            product: Product.sampleData[1], // Will be set when creating invoice
            quantity: 2,
            price: 10.99,
            vatPercentage: 15.0
        ),
        LineItem(
            product: Product.sampleData[0],
            quantity: 1,
            price: 25.50,
            vatPercentage: 15.0
        ),
        LineItem(
            product: Product.sampleData[2],
            quantity: 1,
            price: 25.50,
            vatPercentage: 15.0
        ),
        LineItem(
            product: Product.sampleData[3],
            quantity: 1,
            price: 25.50,
            vatPercentage: 15.0
        ),
        LineItem(
            product: Product.sampleData[4],
            quantity: 1,
            price: 25.50,
            vatPercentage: 15.0
        )
    ]
}

