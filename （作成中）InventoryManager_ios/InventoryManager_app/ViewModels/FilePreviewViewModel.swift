import SwiftUI
import QuickLook

class FilePreviewViewModel: ObservableObject {
    let fileURL: URL

    init(fileURL: URL) {
        self.fileURL = fileURL
    }

    func shareFile(url: URL) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // 少し遅延させる
            let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                if rootViewController.presentedViewController == nil { // 既に表示中でない場合のみ表示
                    rootViewController.present(activityController, animated: true, completion: nil)
                } else {
                    print("UIActivityViewController is already presented.")
                }
            }
        }
    }
}
