import SwiftUI

struct isSelectedSendView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Image("isSelectedSendButton")
        }
        .padding(0)
        .frame(width: 342, height: 56, alignment: .center)
        .background(
          LinearGradient(
            stops: [
              Gradient.Stop(color: Color(red: 0.31, green: 0.14, blue: 0.53), location: 0.00),
              Gradient.Stop(color: Color(red: 0.59, green: 0.26, blue: 0.99), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.47, y: -0.47),
            endPoint: UnitPoint(x: 0.53, y: 1.47)
          )
        )
        .cornerRadius(12)
    }
}

#Preview {
    isSelectedSendView()
}
