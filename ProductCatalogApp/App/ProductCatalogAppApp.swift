//
//  ProductCatalogAppApp.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 07/10/25.
//

import SwiftUI
import SwiftData
import CloudKit

@main
struct ProductCatalogAppApp: App {
    
    //Cloudkit Container
    var modelContainer: ModelContainer
    
    //Cloudkit container id - "iCloud.poc.flyct.invoic"
    //Model Configuration with the cloud container id
    let configuration = ModelConfiguration(
        cloudKitDatabase: .private("iCloud.poc.flyct.product")
    )
    
    init() {
        do {
            self.modelContainer = try ModelContainer(
                for: Product.self, Inventory.self, Customer.self,
                configurations: configuration
            )
        } catch (let err){
            fatalError("Not able to initialize the CloudKit store: \(err.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            Dashboard()
                .modelContainer(modelContainer)
                
        }
    }
}


