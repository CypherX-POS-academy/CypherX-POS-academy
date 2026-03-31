import SwiftUI

struct RecordView: View {
    @State private var isSelected = false

    var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            Image(isSelected ? "isSelectedRecordButton" : "RecordButton")
                .resizable()
                .scaledToFit()
                .frame(width: 358)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    RecordView()
}
