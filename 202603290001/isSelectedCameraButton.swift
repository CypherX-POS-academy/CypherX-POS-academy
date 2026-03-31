import SwiftUI

struct isSelectedCameraView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
        Image("isSelectedCamera")
        }
        .padding(0)
        .frame(width: 32, height: 32, alignment: .center)
        .background(Color(red: 0.15, green: 0.15, blue: 0.15))
        .cornerRadius(9999)
    }
}

#Preview {
    isSelectedCameraView()
}
