//
//  InventoryViewModel.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 07/10/25.
//

import SwiftUI
import SwiftData
import Foundation
import Core

@Observable
class InventoryViewModel {
    private var modelContext: ModelContext?
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    // MARK: - Inventory Management
    
    func addInventory(for product: Product, unitsPerCarton: Int, numberOfCartons: Int) throws {
        guard let context = modelContext else {
            throw InventoryError.noModelContext
        }
        
        let inventory = Inventory(
            product: product,
            unitsPerCarton: unitsPerCarton,
            numberOfCartons: numberOfCartons,
            lastUpdated: .now
        )
        
        context.insert(inventory)
        try context.save()
    }
    
    func deleteInventory(_ inventory: Inventory) throws {
        guard let context = modelContext else {
            throw InventoryError.noModelContext
        }
        
        context.delete(inventory)
        try context.save()
    }
    
    func updateInventory(_ inventory: Inventory, unitsPerCarton: Int, numberOfCartons: Int) throws {
        guard let context = modelContext else {
            throw InventoryError.noModelContext
        }
        
        inventory.unitsPerCarton = unitsPerCarton
        inventory.numberOfCartons = numberOfCartons
        inventory.lastUpdated = .now
        
        try context.save()
    }
    
    // MARK: - Analytics
    
    func getTotalStock(for product: Product, in inventories: [Inventory]) -> Int {
        inventories
            .filter { $0.product?.id == product.id }
            .reduce(0) { $0 + $1.totalUnits }
    }
    
    func getLowStockProducts(in inventories: [Inventory], threshold: Int = 10) -> [Product] {
        let productStockMap = Dictionary(grouping: inventories) { $0.product }
            .compactMapValues { inventories in
                inventories.reduce(0) { $0 + $1.totalUnits }
            }
        
        return productStockMap.compactMap { (product, totalStock) in
            totalStock < threshold ? product : nil
        }
    }
    
    func getInventorySummary(in inventories: [Inventory]) -> InventorySummary {
        let totalProducts = Set(inventories.compactMap { $0.product }).count
        let totalUnits = inventories.reduce(0) { $0 + $1.totalUnits }
        let lowStockCount = getLowStockProducts(in: inventories).count
        
        return InventorySummary(
            totalProducts: totalProducts,
            totalUnits: totalUnits,
            lowStockCount: lowStockCount
        )
    }
}

// MARK: - Supporting Types

struct InventorySummary {
    let totalProducts: Int
    let totalUnits: Int
    let lowStockCount: Int
}

enum InventoryError: LocalizedError {
    case noModelContext
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .noModelContext:
            return "Model context is not available"
        case .invalidData:
            return "Invalid inventory data provided"
        }
    }
}
