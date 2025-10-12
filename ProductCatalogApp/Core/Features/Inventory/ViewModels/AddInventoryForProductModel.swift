//
//  AddInventoryForProductModel.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 12/10/25.
//
import SwiftUI
import SwiftData
import Core

@Observable
class AddInventoryForProductModel {
    
    var selectedProduct: Product?
    
    var selectedProductID: UUID? 
    var unitsPerCarton: Int = 1
    var numberOfCartons: Int = 1
    
    init(_ selected: Product?) {
        self.selectedProduct = selected
        self.selectedProductID = selected?.id
    }
    
    func currentProduct(_ products: [Product]) -> Product? {
        products.first { $0.id == selectedProductID }
    }
    
    func totalUnits() -> Int {
        unitsPerCarton * numberOfCartons
    }
    
    func isValid() -> Bool {
        selectedProductID != nil && unitsPerCarton > 0 && numberOfCartons > 0
    }
    
    func updateSeletedProductFrom(_ products: [Product]) {
        selectedProduct = currentProduct(products)
    }
    
    func imageOf(_ product: Product) -> UIImage? {
        if let imageData = product.imageData,
           let uiImage = UIImage(data: imageData) {
            return uiImage
        }
        return nil
    }
    
    func totalText(_ totalUnits: Int) -> String {
        "\(unitsPerCarton) × \(numberOfCartons) = \(totalUnits)"
    }
    
    func saveInventory(_ context: ModelContext) {
        guard let product = selectedProduct else { return }
        
        let newInventory = Inventory(
            product: product,
            unitsPerCarton: unitsPerCarton,
            numberOfCartons: numberOfCartons,
            lastUpdated: .now
        )
        
        context.insert(newInventory)
        
        do {
            try context.save()
        } catch {
            print("Failed to save inventory: \(error)")
        }
    }
}
