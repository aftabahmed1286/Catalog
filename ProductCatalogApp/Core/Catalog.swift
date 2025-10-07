//
//  ContentView.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 07/10/25.
//

import SwiftUI
import SwiftData

struct Catalog: View {
    
    @Environment(\.modelContext) private var context
    @Query private var products: [Product]
    
    init() {
        _products = Query(FetchDescriptor<Product>())
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    Catalog()
}
