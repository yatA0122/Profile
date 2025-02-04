import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Text("在庫管理システム")
                        .font(.largeTitle)
                        .padding()
                    Text("ログイン")
                        .font(.title)
                        .padding()
                }
                TextField("ID", text: $viewModel.workplaceID)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .keyboardType(.numberPad)
                SecureField("パスワード", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: viewModel.login) {
                    Text("ログイン")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding()
            .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                HomeView()
            }
        }
    }
}

#Preview {
    LoginView()
}
