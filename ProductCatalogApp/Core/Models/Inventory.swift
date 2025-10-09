//
//  Inventory.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 07/10/25.
//
import SwiftUI
import SwiftData

@Model
class Inventory {
    var id: UUID = UUID()
    // Relationship to Product (must have inverse)
    var product: Product?
    
    var unitsPerCarton: Int = 0
    var numberOfCartons: Int = 0
    var lastUpdated: Date = Date.now
    
    // Computed property for total units
    var totalUnits: Int {
        return unitsPerCarton * numberOfCartons
    }
    
    init(
        id: UUID = UUID(),
        product: Product? = nil,
        unitsPerCarton: Int = 0,
        numberOfCartons: Int = 0,
        lastUpdated: Date = .now
    ) {
        self.id = id
        self.product = product
        self.unitsPerCarton = unitsPerCarton
        self.numberOfCartons = numberOfCartons
        self.lastUpdated = lastUpdated
    }
}

// MARK: - @Bindable Support
extension Inventory: @unchecked Sendable {}

extension Inventory {
    
    static var sampleData: [Inventory] = [
        Inventory(
            product: Product.sampleData[0], // Tomato Ketchup
            unitsPerCarton: 1,
            numberOfCartons: 4,
            lastUpdated: .now
        ),
        Inventory(
            product: Product.sampleData[1], // Soy Sauce
            unitsPerCarton: 12,
            numberOfCartons: 15,
            lastUpdated: .now
        ),
        Inventory(
            product: Product.sampleData[2], // Chocolate Chip Cookies
            unitsPerCarton: 36,
            numberOfCartons: 8,
            lastUpdated: .now
        ),
        Inventory(
            product: Product.sampleData[3], // Peanut Butter Cookies
            unitsPerCarton: 36,
            numberOfCartons: 5,
            lastUpdated: .now
        ),
        Inventory(
            product: Product.sampleData[4], // Hot Chili Sauce
            unitsPerCarton: 18,
            numberOfCartons: 12,
            lastUpdated: .now
        )
    ]
}
