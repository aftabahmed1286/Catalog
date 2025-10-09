//
//  InventoryProductRow.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 09/10/25.
//
import SwiftUI

struct InventoryProductRow: View {
    let product: Product
    let inventories: [Inventory]
    
    private var totalStock: Int {
        inventories
            .filter { $0.product?.id == product.id }
            .reduce(0) { $0 + $1.totalUnits }
    }
    
    var body: some View {
        HStack {
            // Product Image
            productImage
            
            productDetail
            
            Spacer()
            
            stockAlert
        }
        .padding(.vertical, 4)
    }
    
    var productImage: some View {
        VStack {
            if let imageData = product.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
        }
    }
    
    var productDetail: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(product.name)
                .font(.headline)
                .lineLimit(1)
            
            Text("Barcode: \(product.barcode)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack {
                Text("Total Stock:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("\(totalStock) units")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(totalStock < 10 ? .red : .primary)
            }
        }
    }
    
    var stockAlert: some View {
        VStack {
            if totalStock < 10 {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                    .font(.title2)
            }
        }
    }
    
    
}
