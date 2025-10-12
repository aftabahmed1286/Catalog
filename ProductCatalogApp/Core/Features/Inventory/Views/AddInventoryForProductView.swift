//
//  AddInventoryForProductView.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 07/10/25.
//

import SwiftUI
import SwiftData

struct AddInventoryForProductView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var products: [Product]
    
    @State var viewModel: AddInventoryForProductModel
    
    init(selectedProduct: Product? = nil) {
        _viewModel = State(wrappedValue: AddInventoryForProductModel(selectedProduct))
    }
    
    private var currentProduct: Product? {
        viewModel.currentProduct(products)
    }
    
    private var totalUnits: Int {
        viewModel.totalUnits()
    }
    
    private var isValid: Bool {
        viewModel.isValid()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Product Selection Section
                Section("Product") {
                    productPicker
                }
                
                // Inventory Details Section
                Section("Inventory Details") {
                    inventoryDetail
                }
                
                // Total Units Summary
                Section("Summary") {
                    summary
                }
            }
            .navigationTitle("Add Inventory")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                cancelButton
                saveButton
            }
        }
    }
    
    var productPicker: some View {
        return Menu {
            VStack {
                Picker("Select Product", selection: $viewModel.selectedProductID)
                {
                    Text("Choose a product")
                        .tag(nil as UUID?)
                    ForEach(products) { product in
                        HStack {
                            if let uiImage = viewModel.imageOf(product) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 30, height: 30)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                            }
                            Text(product.name)
                        }
                        .tag(product.id as UUID?)
                    }
                }
                .pickerStyle(.inline)
                .onChange(of: viewModel.selectedProductID) {
                    viewModel.updateSeletedProductFrom(products)
                }
            }
        } label: {
            VStack {
                if let selected = viewModel.selectedProduct {
                    VStack {
                        HStack {
                                Text(selected.name)
                                Spacer()
                                Text("Select Other")
                        }
                        
                        if let uiImage = viewModel.imageOf(selected) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                        
                    }
                }
                else {
                    Text("Choose a product")
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .foregroundColor(.gray.opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .multilineTextAlignment(.center)
        }
    }
    
    
    var inventoryDetail: some View {
        return VStack(alignment: .leading, spacing: 16) {
            EditStepper(label: "Units per Carton", value: $viewModel.unitsPerCarton, minimum: 1)
            EditStepper(label: "Number of Cartons", value: $viewModel.numberOfCartons, minimum: 1)
        }
    }
    
    var summary: some View {
        return HStack {
            VStack(alignment: .leading) {
                Text("Total Units")
                    .font(.headline)
                Text(viewModel.totalText(totalUnits))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(totalUnits)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
        }
        .padding(.vertical, 8)
    }
    
    var cancelButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") {
                dismiss()
            }
        }
    }
    
    var saveButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save") {
                saveInventory()
            }
            .disabled(!isValid)
        }
    }
    
    private func saveInventory() {
        viewModel.saveInventory(modelContext)
        dismiss()
    }
    
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Product.self, Inventory.self, configurations: config)
    
    // Add sample data
    let context = container.mainContext
    for product in Product.sampleData {
        context.insert(product)
    }
    
    return AddInventoryForProductView()
        .modelContainer(container)
}

#Preview("With Selected Product") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Product.self, Inventory.self, configurations: config)
    
    // Add sample data
    let context = container.mainContext
    for product in Product.sampleData {
        context.insert(product)
    }
    
    return AddInventoryForProductView(selectedProduct: Product.sampleData[0])
        .modelContainer(container)
}
