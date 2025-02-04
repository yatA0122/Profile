import Foundation
import Combine

class ProductListViewModel: ObservableObject {
    @Published var products: [Product] = []

    private let productService = ProductService()
    private var cancellables = Set<AnyCancellable>()

    func fetchProducts() {
        productService.fetchProducts()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("商品一覧取得エラー: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] products in
                self?.products = products
            })
            .store(in: &cancellables)
    }
}
