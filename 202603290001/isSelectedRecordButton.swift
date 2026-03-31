import SwiftUI

struct isSelectedRecordView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 7.99) {
            Image("isSelectedRecordButton")
        }
        .padding(.horizontal, 0)
        .padding(.vertical, 16)
        .frame(width: 358, alignment: .center)
        .background(Color(red: 0.31, green: 0.14, blue: 0.53))
        .cornerRadius(12)
    }
}

#Preview {
    isSelectedRecordView()
}
