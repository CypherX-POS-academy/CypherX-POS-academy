import SwiftUI

struct SendView: View {
    @State private var isSelected = false

    var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            Text("View on Solana Explorer")
                .font(
                    Font.custom("Inter", size: 16)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(
                    isSelected
                    ? Color(red: 0.31, green: 0.14, blue: 0.53)
                    : Color(red: 0.77, green: 0.6, blue: 1)
                )
                .frame(width: 188.91, height: 24, alignment: .center)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SendView()
}
