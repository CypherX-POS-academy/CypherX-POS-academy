import SwiftUI

struct NextView: View {
    @State private var isSelected = false

    var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            Text("Next")
                .font(
                    Font.custom("Inter", size: 16)
                        .weight(.semibold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(
                    isSelected
                    ? Color(red: 0.31, green: 0.14, blue: 0.53)
                    : Color(red: 0.6, green: 0.27, blue: 1)
                )
                .frame(width: 36.3, height: 24, alignment: .center)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NextView()
}
