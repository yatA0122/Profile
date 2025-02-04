import SwiftUI

struct BarcodeScannerScreen: View {
    @Binding var scannedCode: String
    @StateObject private var viewModel = BarcodeScannerViewModel()

    var body: some View {
        VStack {
            Text("バーコードをスキャンしてください")
                .font(.title2)
                .padding()

            BarcodeScannerRepresentable(scannedCode: $scannedCode)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.2))
        }
        .onChange(of: scannedCode) {
            viewModel.handleScannedCode(scannedCode)
        }
        .navigationTitle("バーコードスキャン")
        .navigationBarTitleDisplayMode(.inline)
    }
}
