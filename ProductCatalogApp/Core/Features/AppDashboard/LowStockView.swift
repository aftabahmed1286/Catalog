//
//  LowStockView.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 09/10/25.
//
import SwiftUI
import SwiftData

struct LowStockView: View {
    @Query private var inventories: [Inventory]
    let viewModel: InventoryViewModel
    
    private var lowStockProducts: [Product] {
        viewModel.getLowStockProducts(in: inventories)
    }
    
    var body: some View {
        List {
            if lowStockProducts.isEmpty {
                wellStocked
            } else {
                lowStock
            }
        }
        .navigationTitle("Low Stock Alert")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var wellStocked: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.green)
            
            Text("All products are well stocked!")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    var lowStock: some View {
        ForEach(lowStockProducts) { product in
            NavigationLink(destination: InventoryDetailView(product: product)) {
                HStack {
                    if let imageData = product.imageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            )
                    }
                    
                    VStack(alignment: .leading) {
                        Text(product.name)
                            .font(.headline)
                        
                        Text("Barcode: \(product.barcode)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("\(viewModel.getTotalStock(for: product, in: inventories)) units")
                            .font(.headline)
                            .foregroundColor(.red)
                        
                        Text("Low Stock")
                            .font(.caption)
                        .foregroundColor(.red)
                    }
                }
            }
        }
    }
    
    
}
