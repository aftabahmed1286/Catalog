//
//  CustomerFormView.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 09/10/25.
//
import SwiftUI
import SwiftData

struct CustomerFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var viewModel = CustomerViewModel()
    
    // If customer is nil, we're adding. If not nil, we're editing
    var customer: Customer?
    
    @State private var name: String = ""
    @State private var contactNumber: String = ""
    @State private var email: String = ""
    @State private var trnNumber: String = ""
    @State private var branch: String = ""
    @State private var address: String = ""
    
    init(customer: Customer? = nil) {
        self.customer = customer
        _name = State(initialValue: customer?.name ?? "")
        _contactNumber = State(initialValue: customer?.contactNumber ?? "")
        _email = State(initialValue: customer?.email ?? "")
        _trnNumber = State(initialValue: customer?.trnNumber ?? "")
        _branch = State(initialValue: customer?.branch ?? "")
        _address = State(initialValue: customer?.address ?? "")
    }
    
    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Customer Info") {
                    TextField("Name", text: $name)
                    TextField("Contact #", text: $contactNumber)
                        .keyboardType(.phonePad)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                    TextField("TRN #", text: $trnNumber)
                        .keyboardType(.numberPad)
                    TextField("Branch", text: $branch)
                    TextField("Address", text: $address)
                }
            }
            .navigationTitle(customer == nil ? "Add Customer" : "Edit Customer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { save() }
                        .disabled(!isValid)
                }
            }
            .onAppear {
                viewModel.setModelContext(modelContext)
            }
        }
    }
    
    private func save() {
        do {
            if let customer = customer {
                try viewModel.updateCustomer(customer, name: name, contactNumber: contactNumber, email: email, trnNumber: trnNumber, branch: branch, address: address)
            } else {
                try viewModel.createCustomer(name: name, contactNumber: contactNumber, email: email, trnNumber: trnNumber, branch: branch, address: address)
            }
            dismiss()
        } catch {
            print("Failed to save customer: \(error)")
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Customer.self, configurations: config)
    for c in Customer.sampleData { container.mainContext.insert(c) }
    return CustomerFormView()
        .modelContainer(container)
}
