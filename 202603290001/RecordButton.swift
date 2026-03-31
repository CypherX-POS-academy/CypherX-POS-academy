import SwiftUI

struct RecordView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 7.99) {
            Image("RecordButton")
        }
        .padding(.horizontal, 0)
        .padding(.vertical, 16)
        .frame(width: 358, alignment: .center)
        .background(Color(red: 0.6, green: 0.27, blue: 1))
        .cornerRadius(12)
    }
}

#Preview {
    RecordView()
}
