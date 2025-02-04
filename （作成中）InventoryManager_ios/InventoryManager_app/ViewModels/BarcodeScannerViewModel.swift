import SwiftUI

class BarcodeScannerViewModel: ObservableObject {
    @Published var scannedCode: String = ""

    func handleScannedCode(_ code: String) {
        // スキャンしたコードを処理するロジックをここに追加
        print("スキャン結果: \(code)")
        scannedCode = code
    }
}
