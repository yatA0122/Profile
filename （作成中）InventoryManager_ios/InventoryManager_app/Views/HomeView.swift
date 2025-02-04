import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                NavigationLink(destination: ProductListView()) {
                    Text("一覧")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                }

                NavigationLink(destination: AddProductView()) {
                    Text("新規商品登録")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                }
                
                NavigationLink(destination: BarcodeScannerScreen(scannedCode: $viewModel.janCode)) {
                    Text("入庫・出庫")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                }

                Spacer()
                
                NavigationLink(destination: OutPutExcelView()) {
                    Text("Excel出力")
                        .font(.title)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                }
                
                Spacer()
            }
            .navigationTitle("ホーム")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
