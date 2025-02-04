import Foundation

class LoginViewModel: ObservableObject {
    @Published var workplaceID: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String?

    func login() {
        let loginRequest = LoginRequest(workplace_id: workplaceID, password: password)

        APIService.login(request: loginRequest) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let jsonResponse):
                    if let token = jsonResponse["token"] as? String,
                       let placeName = jsonResponse["placeName"] as? String {
                        KeychainHelper.shared.save(token, forKey: "token")
                        KeychainHelper.shared.save(placeName, forKey: "placeName")
                        self?.isLoggedIn = true
                    } else {
                        self?.errorMessage = "不正なレスポンス形式です"
                        print("workplaceID: \(jsonResponse["workplaceID"] as? String ?? "N/A"), password: \(jsonResponse["password"] as? String ?? "N/A")")
                    }
                case .failure(let error):
                    self?.errorMessage = "ログイン失敗: \(error.localizedDescription)"
                }
            }
        }
    }
}
