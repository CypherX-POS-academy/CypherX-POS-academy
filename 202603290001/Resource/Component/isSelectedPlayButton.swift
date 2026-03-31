import SwiftUI

struct isSelectedPlayView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
        Image("isSelectedPlayButton")
                .frame(width: 25, height: 25)
        }
        .padding(0)
    }
}

#Preview {
    isSelectedPlayView()
}
