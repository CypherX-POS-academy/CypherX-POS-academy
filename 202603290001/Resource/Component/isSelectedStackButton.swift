import SwiftUI

struct isSelectedStackView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
        Image("isSelectedStackButton")
        }
        .padding(0)
        .frame(width: 40, height: 40, alignment: .center)
        .background(.black.opacity(0.4))
        .cornerRadius(9999)
        .overlay(
          RoundedRectangle(cornerRadius: 9999)
            .inset(by: 0.5)
            .stroke(.white.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    isSelectedStackView()
}
