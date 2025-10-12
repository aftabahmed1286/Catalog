//
//  ProductFormView.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 07/10/25.
//
import SwiftUI
import PhotosUI
import SwiftData
import Observation
internal import UniformTypeIdentifiers
import Core

struct ProductFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var viewModel: ProductFormViewModel
    
    init(product: Product? = nil) {
        _viewModel = State(initialValue: ProductFormViewModel(product: product))
    }
    
    var body: some View {
        @Bindable var vm = viewModel
        NavigationStack {
            Form {
                Section("Details") {
                    productInfo
                }
                
                Section("Image") {
                    productImage
                    Button("Choose Image") { vm.showSourceDialog = true }
                }
            }
            .navigationTitle(vm.isNew ? "Add Product" : "Edit Product")
            .confirmationDialog("Select Image Source", isPresented: $vm.showSourceDialog, titleVisibility: .visible) {
                pickImageOptions
            }
            .toolbar {
                cancelButton
                saveButton
            }
            //Photos Picker
            .photosPicker(isPresented: $vm.showPhotoPicker, selection: $vm.selectedPhoto)
            .onChange(of: vm.selectedPhoto) { _, _ in
                Task {
                    await vm.handleSelectedPhotoChange()
                }
            }
            .alert("Camera Unavailable", isPresented: $vm.showCameraUnavailableAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("This device does not have a camera or it is not available.")
            }
            .sheet(isPresented: $vm.showCamera) {
                ImagePicker(sourceType: .camera) { imageData in
                    vm.handleCameraImage(imageData)
                }
            }
            .sheet(isPresented: $vm.showDocumentPicker) {
                DocumentPicker { data in
                    vm.handleDocumentData(data)
                }
            }
        }
    }
    
    var productInfo: some View {
        VStack {
            @Bindable var vm = viewModel
            TextField("Name", text: $vm.product.name)
            TextField("Barcode", text: $vm.product.barcode)
            TextField("Price", value: $vm.product.price, format: .number)
                .keyboardType(.decimalPad)
        }
    }
    
    var productImage: some View {
        VStack {
            if let data = viewModel.product.imageData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .cornerRadius(8)
                    .shadow(radius: 4)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .opacity(0.4)
            }
        }
    }
    
    var pickImageOptions: some View {
        VStack {
            Button("Camera") {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    viewModel.showCamera = true
                } else {
                    viewModel.showCameraUnavailableAlert = true
                }
            }
            #if targetEnvironment(macCatalyst)
            Button("Files") { viewModel.showDocumentPicker = true }
            #else
            Button("Photos Picker") { viewModel.showPhotoPicker = true }
            #endif
            Button("Cancel", role: .cancel) {}
        }
    }
    
    var saveButton: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("Save") {
                viewModel.save(context: context) { dismiss() }
            }
            .disabled(viewModel.product.name.isEmpty)
        }
    }
    
    var cancelButton: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel", role: .cancel) {
                dismiss()
            }
        }
    }
}
