//
//  ProductDetailView.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 07/10/25.
//
import SwiftUI
import SwiftData
import Observation

struct ProductDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var viewModel: ProductDetailViewModel

    init(product: Product) {
        _viewModel = State(initialValue: ProductDetailViewModel(product: product))
    }
    
    var body: some View {
        @Bindable var vm = viewModel
        ScrollView {
            VStack(spacing: 20) {
                productImage
                productDetail
                Spacer()
            }
            .padding()
        }
        .navigationTitle(vm.product.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            editDelete
        }
        .sheet(isPresented: $vm.showEditSheet) {
            ProductFormView(product: vm.product)
        }
    }
    
    var productImage: some View {
        VStack {
            @Bindable var vm = viewModel
            if let imageData = vm.product.imageData,
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
        }
    }
    
    var productDetail: some View {
        VStack {
            @Bindable var vm = viewModel
            Text(vm.product.name)
                .font(.title.bold())
            
            Text("Barcode: \(vm.product.barcode)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text(String(format: "Price: $%.2f", vm.product.price))
                .font(.headline)
                .foregroundColor(.green)
        }
    }
    
    var editDelete: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            @Bindable var vm = viewModel
            Button {
                vm.showEditSheet = true
            } label: {
                Image(systemName: "pencil")
            }
            
            Button(role: .destructive) {
                vm.deleteProduct(context: context) { dismiss() }
            } label: {
                Image(systemName: "trash")
            }
        }
    }
}
