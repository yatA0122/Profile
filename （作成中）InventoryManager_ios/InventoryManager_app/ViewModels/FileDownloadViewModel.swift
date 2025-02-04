import SwiftUI
import Foundation
import Combine

class FileDownloadViewModel: ObservableObject {
    @Published var isDownloading: Bool = false
    @Published var downloadedFileURL: URL?

    private let fileDownloader = FileDownloader()

    func downloadFile() {
        isDownloading = true

        guard let fileURL = URL(string: "\(APIConstants.baseURL)/products/export_excel") else {
            print("Invalid URL")
            isDownloading = false
            return
        }

        fileDownloader.downloadFile(from: fileURL) { [weak self] result in
            DispatchQueue.main.async {
                self?.isDownloading = false
                switch result {
                case .success(let url):
                    self?.downloadedFileURL = url
                case .failure(let error):
                    print("Download error: \(error.localizedDescription)")
                }
            }
        }
    }
}
