//
//  ProductCard.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 07/10/25.
//
import SwiftUI
import SwiftData
import Core

struct ProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(spacing: 8) {
            if let imageData = product.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .cornerRadius(12)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .foregroundStyle(.gray)
                    .opacity(0.4)
            }
            
            Text(product.name)
                .font(.headline)
                .lineLimit(1)
            
            Text(String(format: "$%.2f", product.price))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(radius: 3)
    }
}
