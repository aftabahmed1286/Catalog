//
//  ContentView.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 07/10/25.
//

import SwiftUI
import SwiftData
import Core

struct Catalog: View {
    @Environment(\.modelContext) private var context
    @Query private var products: [Product]
    @Namespace private var animation
    @State private var showAddSheet = false
    
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                ProductFormView()
            }
        }
    }
}

#Preview {
    Catalog()
}
