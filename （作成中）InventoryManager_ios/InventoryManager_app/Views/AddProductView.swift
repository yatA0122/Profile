import SwiftUI

struct AddProductView: View {
    @StateObject private var viewModel = AddProductViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("商品情報")) {
                    TextField("品名を入力", text: $viewModel.productName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("価格", text: $viewModel.priceText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    TextField("商品コードを入力", text: $viewModel.productCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("JANコードを入力", text: $viewModel.janCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    
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
                    TextField("購入箇所を入力", text: $viewModel.purchaseLocation)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Section(header: Text("在庫情報")) {
                    Stepper(value: $viewModel.standardStock, in: 0...1000) {
                        Text("標準在庫数: \(viewModel.standardStock)")
                    }
                    Stepper(value: $viewModel.currentStock, in: 0...1000) {
                        Text("在庫: \(viewModel.currentStock)")
                    }
                }
                
                Section {
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        viewModel.saveProduct()
                    }) {
                        Text("商品を登録")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        
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
                    print("Dismiss called")
                    dismiss()
                }
            }
            .navigationTitle("商品を登録")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView()
    }
}
