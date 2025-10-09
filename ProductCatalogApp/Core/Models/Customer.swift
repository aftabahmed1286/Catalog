//
//  Customer.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 09/10/25.
//
import SwiftUI
import SwiftData

@Model
class Customer {
    var id: UUID = UUID()
    var name: String = ""
    var contactNumber: String = ""
    var email: String = ""
    var trnNumber: String = ""
    var branch: String = ""
    var address: String = ""
    var lastUpdated: Date = Date.now
    
    init(
        id: UUID = UUID(),
        name: String = "",
        contactNumber: String = "",
        email: String = "",
        trnNumber: String = "",
        branch: String = "",
        address: String = "",
        lastUpdated: Date = .now
    ) {
        self.id = id
        self.name = name
        self.contactNumber = contactNumber
        self.email = email
        self.trnNumber = trnNumber
        self.branch = branch
        self.address = address
        self.lastUpdated = lastUpdated
    }
}

extension Customer {
    static var sampleData: [Customer] = [
        Customer(name: "Alice Doe", contactNumber: "+1 555-0101", email: "alice@example.com", trnNumber: "123456789", branch: "Downtown", address: "1 Infinite Loop, Cupertino"),
        Customer(name: "Bob Smith", contactNumber: "+1 555-0102", email: "bob@example.com", trnNumber: "987654321", branch: "Uptown", address: "500 Market St, San Francisco"),
        Customer(name: "Carol Johnson", contactNumber: "+1 555-0103", email: "carol@example.com", trnNumber: "456789123", branch: "Midtown", address: "1600 Amphitheatre Pkwy, Mountain View")
    ]
}
