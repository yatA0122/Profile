import Foundation
import Combine

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var errorMessage: String? = nil
    private let productService = ProductService()
    private var cancellables = Set<AnyCancellable>()

    func fetchProducts() {
        productService.fetchProducts()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = "エラー: \(error.localizedDescription)"
                }
            }, receiveValue: { products in
                self.products = products
            })
            .store(in: &cancellables)
    }
}
