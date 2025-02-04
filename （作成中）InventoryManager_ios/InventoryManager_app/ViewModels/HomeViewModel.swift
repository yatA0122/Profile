import Foundation

class HomeViewModel: ObservableObject {
    @Published var scannedCode: String = ""
    @Published var janCode: String = ""
    // 他のビジネスロジックをここに追加可能
}
