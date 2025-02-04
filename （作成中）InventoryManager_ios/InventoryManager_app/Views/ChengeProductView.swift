import SwiftUI

struct ChengeProductView: View {
    @StateObject private var viewModel: ChengeProductViewModel
    @FocusState private var focusedField: Bool
    @Environment(\.dismiss) private var dismiss

    init(product: Product, onSaveCompletion: (() -> Void)? = nil, onDeleteCompletion: (() -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: ChengeProductViewModel(product: product, onSaveCompletion: onSaveCompletion, onDeleteCompletion: onDeleteCompletion))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("商品情報")) {
                    TextField("品名を入力", text: $viewModel.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($focusedField)

                    TextField("価格", text: $viewModel.price)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .focused($focusedField)

                    TextField("商品コードを入力", text: $viewModel.productCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($focusedField)

                    TextField("JANコードを入力", text: $viewModel.janCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .focused($focusedField)

                    NavigationLink(destination: BarcodeScannerScreen(scannedCode: $viewModel.janCode)) {
                        Text("バーコードを読み取る")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                }

                Section(header: Text("購入情報")) {
                    TextField("購入箇所を入力", text: $viewModel.orderLocation)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($focusedField)
                }

                Section(header: Text("在庫情報")) {
                    Stepper(value: $viewModel.standardStockQuantity, in: 0...1000) {
                        Text("標準在庫数: \(viewModel.standardStockQuantity)")
                    }
                    Stepper(value: $viewModel.stockQuantity, in: 0...1000) {
                        Text("在庫: \(viewModel.stockQuantity)")
                    }
                }

                Button(action: viewModel.deleteProduct) {
                    Text("削除")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("商品を編集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        focusedField = false // フォーカス解除でキーボードを閉じる
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        viewModel.changeSaveProduct()
                    }) {
                        Text("完了")
                    }
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text(viewModel.alertTitle),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onChange(of: viewModel.isSaveComplete) {
                if viewModel.isSaveComplete {
                    dismiss()
                }
            }
        }
    }
}

struct ChengeProductView_Previews: PreviewProvider {
    static var previews: some View {
        ChengeProductView(product: Product(
            id: 1,
            name: "ペーパータオル シングル",
            productCode: "2883033",
            janCode: "4535164054119",
            stockQuantity: 5,
            standardStockQuantity: 10,
            orderLocation: "アスクル",
            price: 4080,
            workplaceID: "415010500"
        ))
    }
}
