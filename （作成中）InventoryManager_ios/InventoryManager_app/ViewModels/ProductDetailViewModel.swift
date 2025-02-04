import Foundation
import Combine

class ProductDetailViewModel: ObservableObject {
    @Published var product: Product
    @Published var amount: Int = 1
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isReturned: Bool = false

    private let productService = ProductService()
    private var cancellables = Set<AnyCancellable>()

    init(product: Product) {
        self.product = product
    }
    
    func updateDetails() {
        guard !isReturned else {
            let publisher = productService.fetchProductDetails(productId: product.id)
            print("productId: \(product.id)") // print はチェーンの外で実行

            publisher
                .receive(on: DispatchQueue.main) // メインスレッドで結果を処理
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        self.alertMessage = "詳細の取得に失敗しました:\n \(error.localizedDescription)"
                        self.showAlert = true
                    case .finished:
                        break
                    }
                }, receiveValue: { fetchedProduct in
                    // 取得した`Product`で`product`を更新
                    self.product = fetchedProduct
                    print("product: self.product")
                })
                .store(in: &cancellables) // メモリリークを防ぐために保持
            return
        }
    }
    

    func updateStock() {
        productService.updateStock(for: product.id, quantity: Int(amount))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.alertMessage = "在庫更新に失敗しました:\n \(error.localizedDescription)"
                    self.showAlert = true
                case .finished:
                    break
                }
            }, receiveValue: { newStock in
                self.alertMessage = "在庫が正常に更新されました。\n新しい在庫数: \(newStock)"
                self.showAlert = true
            })
            .store(in: &cancellables)
    }
}
