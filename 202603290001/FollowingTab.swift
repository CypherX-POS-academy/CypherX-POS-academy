import SwiftUI

struct FollowingView: View {
    @State private var isFollowingSelected = false

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.25)) {
                isFollowingSelected.toggle()
            }
        } label: {
            HStack(spacing: 0) {
                Text("Following")
                    .font(
                        Font.custom("Inter", size: 12)
                            .weight(.bold)
                    )
                    .kerning(1.2)
                    .foregroundColor(.white.opacity(isFollowingSelected ? 1.0 : 0.6))
                    .fixedSize(horizontal: true, vertical: false)
                    .padding(.bottom, 4)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(Color(red: 0.77, green: 0.6, blue: 1))
                            .frame(maxWidth: .infinity)
                            .frame(height: 2)
                            .opacity(isFollowingSelected ? 1 : 0)
                            .offset(y: 2)
                    }

                Spacer()
                    .frame(width: 8)

                Circle()
                    .fill(.white)
                    .frame(width: 4, height: 4)

                Spacer()
                    .frame(width: 8)

                Text("For You")
                    .font(
                        Font.custom("Inter", size: 12)
                            .weight(.bold)
                    )
                    .kerning(1.2)
                    .foregroundColor(.white.opacity(isFollowingSelected ? 0.6 : 1.0))
                    .fixedSize(horizontal: true, vertical: false)
                    .padding(.bottom, 4)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(Color(red: 0.77, green: 0.6, blue: 1))
                            .frame(maxWidth: .infinity)
                            .frame(height: 2)
                            .opacity(isFollowingSelected ? 0 : 1)
                            .offset(y: 2)
                    }
            }
            .frame(maxWidth: .infinity, minHeight: 32, maxHeight: 32, alignment: .center)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.25), value: isFollowingSelected)
    }
}

#Preview {
    FollowingView()
        .frame(width: 200)
}
