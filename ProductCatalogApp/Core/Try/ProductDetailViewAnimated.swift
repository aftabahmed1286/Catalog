//
//  ProductDetailView.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 07/10/25.
//


import SwiftUI

struct ProductDetailViewAnimated: View {
    let product: Product
    @State private var imageScale: CGFloat = 1.0
    
    var body: some View {
        ScrollView {
            GeometryReader { geo in
                let offset = geo.frame(in: .global).minY
                let scale = offset > 0 ? 1 + (offset / 300) : 1 // Stretch when pulled down
                
                if let imageData = product.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                                            .resizable()
                                           .scaledToFit()
                                           .frame(width: 350)
                                            .frame(height: 350)
                                            .scaleEffect(scale, anchor: .center)
                                            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: scale)
                                            .clipped()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        //.frame(width: UIScreen.main.bounds.width,
                        //       height: max(220, 220 + offset))
                        .foregroundStyle(.gray)
                        .opacity(0.5)
                        .scaleEffect(scale)
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: scale)
                }
            }
            .frame(height: 220)
            .ignoresSafeArea(edges: .top)
            
            VStack(spacing: 20) {
                Text(product.name)
                    .font(.title.bold())
                
                Text("Barcode: \(product.barcode)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(String(format: "Price: $%.2f", product.price))
                    .font(.headline)
                    .foregroundColor(.green)
                
                Spacer(minLength: 50)
            }
            .padding(.horizontal)
            .padding(.top, 16)
        }
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    ProductDetailViewAnimated(product: Product(
//        name: "Tomato Ketchup",
//        barcode: "SC001",
//        price: 2.99,
//        imageData: Product.loadImage(named: "tomato"),
//        lastUpdated: .now
//    ))
//}


