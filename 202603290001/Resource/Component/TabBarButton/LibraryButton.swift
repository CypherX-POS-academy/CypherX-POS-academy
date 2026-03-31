import SwiftUI

struct LibraryButton: View {
    var body: some View {
        VStack(alignment: .center, spacing: 3.5) {
            Image("LibraryButton")
              .frame(width: 18.49989, height: 18.49989)
        }
        .padding(0)
        .opacity(0.6)
        .padding(0)
        .opacity(0.6)
    }
}

#Preview {
    LibraryButton()
}
