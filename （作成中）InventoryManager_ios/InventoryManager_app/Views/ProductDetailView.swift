import SwiftUI

struct ProductDetailView: View {
    @StateObject private var viewModel: ProductDetailViewModel
    @State private var isReturned = false

    init(product: Product) {
        _viewModel = StateObject(wrappedValue: ProductDetailViewModel(product: product))
    }

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    HStack {
                        Text("品名").font(.headline)
                        Spacer()
                        Text(viewModel.product.name).font(.body)
                    }
                    HStack {
                        Text("価格").font(.headline)
                        Spacer()
                        Text("\(viewModel.product.price)円").font(.body)
                    }
                    HStack {
                        Text("商品コード").font(.headline)
                        Spacer()
                        Text(viewModel.product.productCode).font(.body)
                    }
                    HStack {
                        Text("JANコード").font(.headline)
                        Spacer()
                        Text(viewModel.product.janCode).font(.body)
                    }
                    HStack {
                        Text("標準在庫数").font(.headline)
                        Spacer()
                        Text(String(viewModel.product.standardStockQuantity)).font(.body)
                    }
                    HStack {
                        Text("購入箇所").font(.headline)
                        Spacer()
                        Text(viewModel.product.orderLocation).font(.body)
                    }
                }
                Spacer()
                
                Stepper("在庫: \(viewModel.amount)", value: $viewModel.amount, in: 1...1000)
                    .onAppear {
                        viewModel.amount = viewModel.product.stockQuantity
                    }
                    .padding()
                    .font(.title2)
                Button(action: {
                    viewModel.updateStock()
                }) {
                    Text("更新")
                        .font(.title)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                }
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(
                        title: Text("更新完了"),
                        message: Text(viewModel.alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .navigationTitle("商品詳細")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ChengeProductView(product: viewModel.product)
                    ) {
                        Text("編集")
                    }
                }
            }
            .onAppear {
                isReturned = true
                viewModel.updateDetails()
            }
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(
            product: Product(
                id: 1,
                name: "ペーパータオル シングル",
                productCode: "2883033",
                janCode: "4535164054119",
                stockQuantity: 5,
                standardStockQuantity: 10,
                orderLocation: "アスクル",
                price: 4080,
                workplaceID: "41510500"
            )
        )
    }
}
