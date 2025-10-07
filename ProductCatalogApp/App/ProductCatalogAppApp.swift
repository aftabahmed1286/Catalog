//
//  ProductCatalogAppApp.swift
//  ProductCatalogApp
//
//  Created by Aftab Ahmed on 07/10/25.
//

import SwiftUI
import SwiftData

@main
struct ProductCatalogAppApp: App {
    
    //Cloudkit Container
    var modelContainer: ModelContainer
    
    //Cloudkit container id - "iCloud.poc.flyct.invoic"
    //Model Configuration with the cloud container id
    let configuration = ModelConfiguration(
        "iCloud.poc.flyct.invoic"
    )
    
    init() {
        do {
            self.modelContainer = try ModelContainer(for: Product.self , configurations: configuration)
        } catch {
            fatalError("Not able to initialize the CloudKit store")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}
