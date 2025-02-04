import SwiftUI

struct ProductListView: View {
    @StateObject private var viewModel = ProductListViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.products, id: \.id) { product in
                NavigationLink(destination: ProductDetailView(product: product)) {
                    HStack {
                        Text(product.name).font(.headline)
                        Spacer()
                        Text("在庫： \(product.stockQuantity)").font(.subheadline)
                    }
                }
            }
            .navigationTitle("商品一覧")
            .onAppear {
                viewModel.fetchProducts()
            }
        }
    }
}
