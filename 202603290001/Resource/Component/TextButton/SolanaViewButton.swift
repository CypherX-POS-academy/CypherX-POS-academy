import SwiftUI

struct SolanaView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image("SolanaViewButton")
        }
        .padding(.horizontal, 0)
        .padding(.top, 12)
        .padding(.bottom, 0)
        .cornerRadius(12)
    }
}

#Preview {
    SolanaView()
}
