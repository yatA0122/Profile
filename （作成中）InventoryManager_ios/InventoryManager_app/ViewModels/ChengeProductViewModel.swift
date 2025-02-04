import SwiftUI
import Combine

class ChengeProductViewModel: ObservableObject {
    @Published var isSaveComplete: Bool = false
    @Published var name: String
    @Published var productCode: String
    @Published var janCode: String
    @Published var orderLocation: String
    @Published var standardStockQuantity: Int
    @Published var stockQuantity: Int
    @Published var price: String
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    var workplaceID: String = ""


    private let productService = ProductService()
    private let product: Product
    private var cancellables = Set<AnyCancellable>()
    
    var onSaveCompletion: (() -> Void)?
    var onDeleteCompletion: (() -> Void)?

    let dismissPublisher = PassthroughSubject<Void, Never>()

    init(product: Product, onSaveCompletion: (() -> Void)? = nil, onDeleteCompletion: (() -> Void)? = nil) {
        self.product = product
        self.name = product.name
        self.productCode = product.productCode
        self.janCode = product.janCode
        self.orderLocation = product.orderLocation
        self.standardStockQuantity = product.standardStockQuantity
        self.stockQuantity = product.stockQuantity
        self.price = "\(product.price)"
        self.workplaceID = product.workplaceID
        self.onSaveCompletion = onSaveCompletion
        self.onDeleteCompletion = onDeleteCompletion
    }

    func changeSaveProduct() {
        guard let priceValue = Int(price) else { return }

        let updatedProduct = Product(
            id: product.id,
            name: name,
            productCode: productCode,
            janCode: janCode,
            stockQuantity: stockQuantity,
            standardStockQuantity: standardStockQuantity,
            orderLocation: orderLocation,
            price: priceValue,
            workplaceID: workplaceID
        )

        productService.updateProduct(product: updatedProduct)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.alertTitle = "更新失敗"
                    self.alertMessage = "\(error.localizedDescription)"
                case .finished:
                    self.alertTitle = "更新完了"
                    self.alertMessage = "正常に更新されました。"
                    DispatchQueue.main.async {
                        self.isSaveComplete = true
                        self.onSaveCompletion?()
                        print("isSaveComplete updated to true")
                    }
                }
                self.showAlert = true
            }, receiveValue: { _ in
                // Void型のため、特に処理なし
            })
            .store(in: &cancellables)
    }

    func deleteProduct() {
        productService.deleteProduct(productId: product.id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.alertTitle = "削除失敗"
                    self.alertMessage = "\(error.localizedDescription)"
                case .finished:
                    self.alertTitle = "削除完了"
                    self.alertMessage = "\(self.product.name)"
                    DispatchQueue.main.async {
                        self.isSaveComplete = true
                        self.onSaveCompletion?()
                        print("isSaveComplete updated to true")
                    }
                }
                self.showAlert = true
            }, receiveValue: { _ in
                // Void型のため、特に処理なし
            })
            .store(in: &cancellables)
    }
}
