import SwiftUI

struct FilePreviewView: View {
    @StateObject private var viewModel: FilePreviewViewModel
    let onComplete: @MainActor () async -> Void

    init(fileURL: URL, onComplete: @escaping @MainActor () async -> Void) {
        self._viewModel = StateObject(wrappedValue: FilePreviewViewModel(fileURL: fileURL))
        self.onComplete = onComplete
    }

    var body: some View {
        NavigationView {
            QuickLookPreview(fileURL: viewModel.fileURL)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            viewModel.shareFile(url: viewModel.fileURL)
                        }) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: HomeView()) {
                        Text("完了")
                    }
                }
            }
        }
    }
}
