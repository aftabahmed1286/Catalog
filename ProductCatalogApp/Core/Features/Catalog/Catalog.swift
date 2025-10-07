//
//  ContentView.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 07/10/25.
//

import SwiftUI
import SwiftData

//struct Catalog: View {
//    
//    @Environment(\.modelContext) private var context
//    @Query private var products: [Product]
//    
//    init() {
//        _products = Query(FetchDescriptor<Product>())
//    }
//    
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}

import SwiftUI
import SwiftData

struct Catalog: View {
    @Environment(\.modelContext) private var context
    @Query private var products: [Product]
    @Namespace private var animation
    
    init() {
        _products = Query(FetchDescriptor<Product>(
            sortBy: [SortDescriptor(\.name)]
        ))
    }
    
    var displayProducts: [Product] {
        products.isEmpty ? Product.sampleData : products
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)]) {
                    ForEach(displayProducts, id: \.id) { product in
                        NavigationLink {
                            ProductDetailView(product: product)
                                .matchedGeometryEffect(id: product.id, in: animation)
                        } label: {
                            ProductCard(product: product)
                                .matchedGeometryEffect(id: product.id, in: animation)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
                .animation(.spring(duration: 0.4), value: products.count)
            }
            .navigationTitle("Catalog")
        }
    }
}

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

struct ProductDetailView: View {
    let product: Product
    
    var body: some View {
        VStack(spacing: 20) {
            if let imageData = product.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 220)
                    .cornerRadius(16)
                    .shadow(radius: 6)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 220)
                    .foregroundStyle(.gray)
                    .opacity(0.5)
            }
            
            Text(product.name)
                .font(.title.bold())
            
            Text("Barcode: \(product.barcode)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text(String(format: "Price: $%.2f", product.price))
                .font(.headline)
                .foregroundColor(.green)
            
            Spacer()
        }
        .padding()
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
        .transition(.asymmetric(insertion: .scale.combined(with: .opacity),
                                removal: .opacity))
    }
}

#Preview {
    Catalog()
}
