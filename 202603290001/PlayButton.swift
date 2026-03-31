import SwiftUI

struct PlayView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
        Image("PlayButton")
                .frame(width: 25, height: 25)
        }
        .padding(0)
    }
}

#Preview {
    PlayView()
}
