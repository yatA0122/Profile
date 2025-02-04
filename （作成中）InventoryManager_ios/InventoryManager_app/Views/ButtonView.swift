import SwiftUI

struct ButtonView: View {
    var label: String
    var color: Color

    var body: some View {
        Text(label)
            .font(.largeTitle)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(50)
    }
}
