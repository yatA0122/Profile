import Foundation
import Combine

class AddProductViewModel: ObservableObject {
    @Published var isSaveComplete: Bool = false
    @Published var productName: String = ""
    @Published var productCode: String = ""
    @Published var janCode: String = ""
    @Published var purchaseLocation: String = ""
    @Published var standardStock: Int = 0
    @Published var currentStock: Int = 0
    @Published var priceText: String = ""
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    var workplaceID: String = ""

    private let productService = ProductService()
    private var cancellables: Set<AnyCancellable> = []
    
    

    func saveProduct() {
        guard let price = Int(priceText) else {
            print("価格が正しくありません")
            return
        }

        let product = Product(
            id: 0,
            name: productName,
            productCode: productCode,
            janCode: janCode,
            stockQuantity: currentStock,
            standardStockQuantity: standardStock,
            orderLocation: purchaseLocation,
            price: price,
            workplaceID: workplaceID
        )

        productService.saveProduct(
            name: product.name,
            productCode: product.productCode,
            janCode: product.janCode,
            stock: product.stockQuantity,
            standardStock: product.standardStockQuantity,
            location: product.orderLocation,
            price: product.price,
            workplace_id: product.workplaceID
        )
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                self.alertTitle = "新規登録失敗"
                self.alertMessage = "\(error.localizedDescription)"
            case .finished:
                self.alertTitle = "新規登録完了"
                self.alertMessage = "\(product.name)"
                DispatchQueue.main.async {
                    self.isSaveComplete = true
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
