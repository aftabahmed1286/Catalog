//
//  Product.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 07/10/25.
//
import SwiftUI
import SwiftData

@Model
class Product {
    var id: UUID = UUID()
    var name: String = ""
    var barcode: String = ""
    var price: Double = 0.0
    var imageData: Data?
    var lastUpdated: Date = Date.now

    init(
        id: UUID = UUID(),
        name: String = "",
        barcode: String = "",
        price: Double = 0.0,
        imageData: Data? = nil,
        lastUpdated: Date = .now
    ) {
        self.id = id
        self.name = name
        self.barcode = barcode
        self.price = price
        self.imageData = imageData
        self.lastUpdated = lastUpdated
    }
}

extension Product {
    
    static var sampleData : [Product] = [
        Product(
            name: "Tomato Ketchup",
            barcode: "SC001",
            price: 2.99,
            imageData: loadImage(named: "tomato"),
            lastUpdated: .now
        ),
        Product(
            name: "Soy Sauce",
            barcode: "SC002",
            price: 3.49,
            imageData: loadImage(named: "baikal"),
            lastUpdated: .now
        ),
        Product(
            name: "Chocolate Chip Cookies",
            barcode: "CK001",
            price: 4.99,
            imageData: loadImage(named: "apple"),
            lastUpdated: .now
        ),
        Product(
            name: "Peanut Butter Cookies",
            barcode: "CK002",
            price: 5.49,
            imageData: loadImage(named: "tomato"),
            lastUpdated: .now
        ),
        Product(
            name: "Hot Chili Sauce",
            barcode: "SC003",
            price: 3.99,
            imageData: loadImage(named: "baikal"),
            lastUpdated: .now
        )
    ]

    
    static func loadImage(named name: String) -> Data? {
        guard let image = UIImage(named: name) else {
            return nil
        }
        return image.pngData()
    }
}
