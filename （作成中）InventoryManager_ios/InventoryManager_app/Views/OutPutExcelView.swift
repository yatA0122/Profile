import SwiftUI

struct OutPutExcelView: View {
    @StateObject private var viewModel = FileDownloadViewModel()
    @State private var showPreview = false

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isDownloading {
                    VStack {
                        ProgressView("ファイル作成中...") // ぐるぐるマーク
                            .progressViewStyle(CircularProgressViewStyle())
                        Text("しばらくお待ちください")
                            .padding(.top)
                    }
                } else {
                    Button(action: {
                        viewModel.downloadFile()
                    }) {
                        Text("Excelをダウンロード")
                            .frame(maxWidth: .infinity, maxHeight: 10)
                            .padding()
                            .cornerRadius(8)
                            .padding(.horizontal, 20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 2) // 枠線の色と太さを指定
                            )
                    }
                    .padding()
                }

                // ダウンロード完了時にプレビューを埋め込む
                if let fileURL = viewModel.downloadedFileURL {
                    FilePreviewView(fileURL: fileURL) {
                        // プレビューを閉じる処理
                        viewModel.downloadedFileURL = nil
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            .navigationTitle("Excel出力")
        }
    }
}

#Preview {
    OutPutExcelView()
}
