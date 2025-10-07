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