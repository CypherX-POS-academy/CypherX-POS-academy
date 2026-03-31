import SwiftUI

struct isSelectedViewButtonView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
        Image("isSelectedViewButton")
        }
        .padding(0)
        .frame(width: 32, height: 32, alignment: .center)
        .background(Color(red: 0.15, green: 0.15, blue: 0.15))
        .cornerRadius(9999)
    }
}

#Preview {
    isSelectedViewButtonView()
}
