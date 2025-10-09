//
//  CustomerViewModel.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 09/10/25.
//
import SwiftUI
import SwiftData

@Observable
class CustomerViewModel {
    private var modelContext: ModelContext?
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    // MARK: - CRUD
    func createCustomer(name: String, contactNumber: String, email: String, trnNumber: String, branch: String, address: String) throws {
        guard let context = modelContext else { throw CustomerError.noModelContext }
        let customer = Customer(name: name, contactNumber: contactNumber, email: email, trnNumber: trnNumber, branch: branch, address: address, lastUpdated: .now)
        context.insert(customer)
        try context.save()
    }
    
    func updateCustomer(_ customer: Customer, name: String, contactNumber: String, email: String, trnNumber: String, branch: String, address: String) throws {
        guard let context = modelContext else { throw CustomerError.noModelContext }
        customer.name = name
        customer.contactNumber = contactNumber
        customer.email = email
        customer.trnNumber = trnNumber
        customer.branch = branch
        customer.address = address
        customer.lastUpdated = .now
        try context.save()
    }
    
    func deleteCustomer(_ customer: Customer) throws {
        guard let context = modelContext else { throw CustomerError.noModelContext }
        context.delete(customer)
        try context.save()
    }
}

enum CustomerError: LocalizedError {
    case noModelContext
    
    var errorDescription: String? {
        switch self {
        case .noModelContext:
            return "Model context is not available"
        }
    }
}
