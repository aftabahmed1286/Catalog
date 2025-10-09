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
    
    let selectedProduct: Product?
    
    @State private var selectedProductID: UUID?
    @State private var unitsPerCarton: Int = 1
    @State private var numberOfCartons: Int = 1
    
    init(selectedProduct: Product? = nil) {
        self.selectedProduct = selectedProduct
        self._selectedProductID = State(initialValue: selectedProduct?.id)
    }
    
    private var currentProduct: Product? {
        products.first { $0.id == selectedProductID }
    }
    
    private var totalUnits: Int {
        unitsPerCarton * numberOfCartons
    }
    
    private var isValid: Bool {
        selectedProductID != nil && unitsPerCarton > 0 && numberOfCartons > 0
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Product Selection Section
                Section("Product") {
                    productDetail
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
    
    var productDetail: some View {
        VStack (spacing: 20){
            productPicker
            
            if let selectedProduct = selectedProduct {
                // Pre-selected product
                HStack {
                    if let imageData = selectedProduct.imageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        
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
                        Text(selectedProduct.name)
                            .font(.headline)
                        Text("Barcode: \(selectedProduct.barcode)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
            }
//            else {
//                // Product picker
//                
//            }
        }
    }
    
    var productPicker: some View {
        Picker("Select Product", selection: $selectedProductID) {
            Text("Choose a product")
                .tag(nil as UUID?)
            
            ForEach(products) { product in
                HStack {
                    if let imageData = product.imageData,
                       let uiImage = UIImage(data: imageData) {
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
    }
    
    
    
    var inventoryDetail: some View {
        VStack(alignment: .leading, spacing: 16) {
            EditStepper(label: "Units per Carton", value: $unitsPerCarton, minimum: 1)
            EditStepper(label: "Number of Cartons", value: $numberOfCartons, minimum: 1)
        }
    }
    
    var summary: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Total Units")
                    .font(.headline)
                Text("\(unitsPerCarton) × \(numberOfCartons) = \(totalUnits)")
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
        guard let product = currentProduct else { return }
        
        let newInventory = Inventory(
            product: product,
            unitsPerCarton: unitsPerCarton,
            numberOfCartons: numberOfCartons,
            lastUpdated: .now
        )
        
        modelContext.insert(newInventory)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save inventory: \(error)")
        }
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
