//
//  ProductFormViewModel.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 08/10/25.
//
import Foundation
import SwiftUI
import PhotosUI
import SwiftData
import Observation

@Observable
final class ProductFormViewModel {
    var product: Product
    var isNew: Bool
    
    // UI State
    var showSourceDialog = false
    var showCamera = false
    var showPhotoPicker = false
    var showDocumentPicker = false
    var showCameraUnavailableAlert = false
    
    // Pickers
    var selectedPhoto: PhotosPickerItem?
    
    init(product: Product? = nil) {
        if let product {
            self.product = product
            self.isNew = false
        } else {
            self.product = Product()
            self.isNew = true
        }
    }
    
    @MainActor
    func handleSelectedPhotoChange() async {
        guard let selectedPhoto else { return }
        if let data = try? await selectedPhoto.loadTransferable(type: Data.self) {
            product.imageData = data
        }
    }
    
    func handleCameraImage(_ imageData: Data) {
        product.imageData = imageData
    }
    
    func handleDocumentData(_ data: Data) {
        product.imageData = data
    }
    
    func save(context: ModelContext, dismiss: () -> Void) {
        if isNew { context.insert(product) }
        do {
            try context.save()
        } catch (let err){
            print("Err: \(err.localizedDescription)")
        }
        dismiss()
    }
}


