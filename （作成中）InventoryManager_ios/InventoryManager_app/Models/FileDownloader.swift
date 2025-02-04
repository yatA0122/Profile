import Foundation

class FileDownloader {
    func downloadFile(from url: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { tempFileURL, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let tempFileURL = tempFileURL, let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                return
            }

            // Content-Disposition ヘッダーからファイル名を取得
            let contentDisposition = httpResponse.allHeaderFields["Content-Disposition"] as? String
            let filename = self.extractFilename(from: contentDisposition) ?? "default_filename.xlsx"
            print("filename: \(filename)")
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationURL = documentsURL.appendingPathComponent(filename)

            do {
                // 既存ファイルがあれば削除
                if fileManager.fileExists(atPath: destinationURL.path) {
                    try fileManager.removeItem(at: destinationURL)
                }
                // ファイルを移動
                try fileManager.moveItem(at: tempFileURL, to: destinationURL)
                completion(.success(destinationURL))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    private func extractFilename(from contentDisposition: String?) -> String? {
        guard let contentDisposition = contentDisposition else { return nil }

        let pattern = "filename=\"([^\"]+)\""
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: contentDisposition.utf16.count)

        if let match = regex?.firstMatch(in: contentDisposition, options: [], range: range),
           let filenameRange = Range(match.range(at: 1), in: contentDisposition) {
            return String(contentDisposition[filenameRange])
        }

        return nil
    }
}
