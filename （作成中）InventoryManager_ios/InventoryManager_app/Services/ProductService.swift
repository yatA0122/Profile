import Foundation
import Combine


struct APIHelper {
    /// 共通リクエスト生成ヘルパー
    static func createRequest(
        url: URL,
        method: String,
        token: String? = nil,
        body: Data? = nil,
        headers: [String: String] = [:]
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let body = body {
            request.httpBody = body
        }

        return request
    }
}

enum APIError: Error {
    case invalidURL                  // URLが無効
    case authenticationRequired      // 認証情報が必要
    case encodingError               // エンコーディングエラー
    case networkError(Error)         // ネットワークエラー
    case decodingError(Error)        // デコードエラー
    case serverError(Int)            // サーバーエラー (ステータスコード含む)
    case unknown(Error)              // 未知のエラー
}

class ProductService {
    /// 商品一覧を取得
    func fetchProducts() -> AnyPublisher<[Product], APIError> {
        guard let url = URL(string: "\(APIConstants.baseURL)/products") else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }

        guard let token = KeychainHelper.shared.retrieve(forKey: "token") else {
            return Fail(error: .authenticationRequired).eraseToAnyPublisher()
        }

        let request = APIHelper.createRequest(url: url, method: "GET", token: token)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                    throw APIError.networkError(URLError(.badServerResponse))
                }
                return output.data
            }
            .decode(type: [Product].self, decoder: JSONDecoder())
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    return .decodingError(decodingError)
                }
                return .networkError(error)
            }
            .eraseToAnyPublisher()
    }

    /// 商品を保存
    func saveProduct(
        name: String,
        productCode: String,
        janCode: String,
        stock: Int,
        standardStock: Int,
        location: String,
        price: Int,
        workplace_id: String
    ) -> AnyPublisher<Void, APIError> {
        guard let url = URL(string: "\(APIConstants.baseURL)/products") else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }

        guard let token = KeychainHelper.shared.retrieve(forKey: "token") else {
            return Fail(error: .authenticationRequired).eraseToAnyPublisher()
        }
        
        guard let workplace_id = KeychainHelper.shared.retrieve(forKey: "workplaceID") else {
            return Fail(error: .authenticationRequired).eraseToAnyPublisher()
        }

        let productData: [String: Any] = [
            "name": name,
            "product_code": productCode,
            "jan_code": janCode,
            "stock_quantity": stock,
            "standard_stock_quantity": standardStock,
            "order_location": location,
            "price": price,
            "workplace_id": workplace_id
        ]

        guard let body = try? JSONSerialization.data(withJSONObject: productData, options: []) else {
            return Fail(error: .encodingError).eraseToAnyPublisher()
        }

        let request = APIHelper.createRequest(url: url, method: "POST", token: token, body: body)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                    throw APIError.networkError(URLError(.badServerResponse))
                }
            }
            .mapError { .networkError($0) }
            .eraseToAnyPublisher()
    }

    /// 商品詳細を取得
    func fetchProductDetails(productId: Int) -> AnyPublisher<Product, APIError> {
        guard let url = URL(string: "\(APIConstants.baseURL)/products/\(productId)") else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }

        guard let token = KeychainHelper.shared.retrieve(forKey: "token") else {
            return Fail(error: .authenticationRequired).eraseToAnyPublisher()
        }

        let request = APIHelper.createRequest(url: url, method: "GET", token: token)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                    throw APIError.networkError(URLError(.badServerResponse))
                }
                return output.data
            }
            .decode(type: Product.self, decoder: JSONDecoder())
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    return .decodingError(decodingError)
                }
                return .networkError(error)
            }
            .eraseToAnyPublisher()
    }

    /// 商品を更新
    func updateProduct(product: Product) -> AnyPublisher<Void, APIError> {
        guard let url = URL(string: "\(APIConstants.baseURL)/products/\(product.id)") else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }

        guard let token = KeychainHelper.shared.retrieve(forKey: "token") else {
            return Fail(error: .authenticationRequired).eraseToAnyPublisher()
        }

        guard let body = try? JSONEncoder().encode(product) else {
            return Fail(error: .encodingError).eraseToAnyPublisher()
        }

        let request = APIHelper.createRequest(url: url, method: "PATCH", token: token, body: body)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }

                // ステータスコードが200または204であるか確認
                guard (200...204).contains(response.statusCode) else {
                    throw APIError.serverError(response.statusCode)
                }

                // 成功の場合はVoidを返す
                return
            }
            .mapError { error in
                // エラーをAPIError型に変換
                if let apiError = error as? APIError {
                    return apiError
                } else {
                    return .unknown(error)
                }
            }
            .eraseToAnyPublisher()
    }

    /// 商品を削除
    func deleteProduct(productId: Int) -> AnyPublisher<Void, APIError> {
        guard let url = URL(string: "\(APIConstants.baseURL)/products/\(productId)") else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }

        guard let token = KeychainHelper.shared.retrieve(forKey: "token") else {
            return Fail(error: .authenticationRequired).eraseToAnyPublisher()
        }

        let request = APIHelper.createRequest(url: url, method: "DELETE", token: token)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                    throw APIError.networkError(URLError(.badServerResponse))
                }
            }
            .mapError { .networkError($0) }
            .eraseToAnyPublisher()
    }

    /// 在庫を更新
    func updateStock(for productId: Int, quantity: Int) -> AnyPublisher<Int, APIError> {
        guard let url = URL(string: "\(APIConstants.baseURL)/products/\(productId)") else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }

        guard let token = KeychainHelper.shared.retrieve(forKey: "token") else {
            return Fail(error: .authenticationRequired).eraseToAnyPublisher()
        }

        let stockData: [String: Any] = [
            "stock_quantity": quantity
        ]

        guard let body = try? JSONSerialization.data(withJSONObject: stockData, options: []) else {
            return Fail(error: .encodingError).eraseToAnyPublisher()
        }

        let request = APIHelper.createRequest(url: url, method: "PATCH", token: token, body: body)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                    throw APIError.networkError(URLError(.badServerResponse))
                }
                do {
                    guard let data = try JSONSerialization.jsonObject(with: output.data, options: []) as? [String: Any],
                          let stockQuantity = data["stock_quantity"] as? Int else {
                        throw APIError.decodingError(NSError(domain: "DecodingError", code: 0, userInfo: nil))
                    }
                    return stockQuantity
                    // `stockQuantity` を使用する処理を記述
                } catch {
                    throw APIError.decodingError(error)
                }             
            }
            .mapError { error -> APIError in
                if let apiError = error as? APIError {
                    return apiError
                }
                // 明示的にエラーをキャスト
                return .networkError(error as Error)
            }
            .eraseToAnyPublisher()
    }
}
