//
//  ProductPickerView.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 11/10/25.
//
import SwiftUI

struct ProductPickerView: View {
    let products: [Product]
    let onProductSelected: (Product) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List(products) { product in
                Button(action: {
                    onProductSelected(product)
                    dismiss()
                }) {
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
                            Text("$\(product.price, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        
                        Spacer()
                    }
                }
                .buttonStyle(.plain)
            }
            .navigationTitle("Select Product")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
