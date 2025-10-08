//
//  ProductDetailViewModel.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 08/10/25.
//
import Foundation
import SwiftUI
import SwiftData
import Observation

@Observable
final class ProductDetailViewModel {
    var product: Product
    var showEditSheet = false
    
    init(product: Product) {
        self.product = product
    }
    
    func deleteProduct(context: ModelContext, dismiss: () -> Void) {
        context.delete(product)
        try? context.save()
        dismiss()
    }
}


