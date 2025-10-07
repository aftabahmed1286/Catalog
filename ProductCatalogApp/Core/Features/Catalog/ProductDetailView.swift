struct ProductDetailView: View {
    let product: Product
    
    var body: some View {
        VStack(spacing: 20) {
            if let imageData = product.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 220)
                    .cornerRadius(16)
                    .shadow(radius: 6)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 220)
                    .foregroundStyle(.gray)
                    .opacity(0.5)
            }
            
            Text(product.name)
                .font(.title.bold())
            
            Text("Barcode: \(product.barcode)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text(String(format: "Price: $%.2f", product.price))
                .font(.headline)
                .foregroundColor(.green)
            
            Spacer()
        }
        .padding()
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
        .transition(.asymmetric(insertion: .scale.combined(with: .opacity),
                                removal: .opacity))
    }
}