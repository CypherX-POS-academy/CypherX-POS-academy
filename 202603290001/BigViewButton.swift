import SwiftUI

struct BigView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Image("BigViewButton")
        }
        .padding(0)
        .frame(width: 64, height: 64, alignment: .center)
        .background(Color(red: 0.77, green: 0.6, blue: 1).opacity(0.1))
        .cornerRadius(9999)
    }
}

#Preview {
    BigView()
}
