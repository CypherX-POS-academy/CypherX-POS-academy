//
//  MyPageView.swift
//  202603290001
//
//  Created by Riolu on 3/31/26.
//

import SwiftUI
 
struct MyPageView: View {
    var body: some View {
        ZStack {
            Color(hex: "#0D0D0D").ignoresSafeArea()
 
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ProfileHeaderSection()
                    StatsSection()
                    FeaturedVideoSection()
                    DanceStylesSection()
                    LatestProofsSection()
 
                    Spacer().frame(height: 100) // 탭바 공간
                }
            }
        }
        .navigationBarHidden(true)
    }
}
 
// MARK: - 프로필 헤더 섹션
struct ProfileHeaderSection: View {
    var body: some View {
        VStack(spacing: 14) {
            Spacer().frame(height: 60) // 네비바 공간
 
            // 프로필 이미지
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#BF5AF2"), Color(hex: "#FF6B6B")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 96, height: 96)
                    .overlay(
                        // 실제 프로필 이미지 자리
                        Circle()
                            .fill(Color(hex: "#2A2A2A"))
                            .frame(width: 90, height: 90)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                            )
                    )
 
                // 인증 뱃지
                Circle()
                    .fill(Color(hex: "#BF5AF2"))
                    .frame(width: 26, height: 26)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                    )
                    .offset(x: 2, y: 2)
            }
 
            // 이름
            Text("Elena Voss")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
 
            // 타이틀 뱃지
            Text("MASTER CHOREOGRAPHER")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.white)
                .tracking(1.2)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(Color(hex: "#BF5AF2").opacity(0.4))
                .clipShape(Capsule())
                .background(
                    Capsule()
                        .stroke(Color(hex: "#BF5AF2"), lineWidth: 1.5)
                )
 
            // 소개글
            Text("Defining modern movement through\ncinematic performance and immutable\ndigital legacies.")
                .font(.system(size: 14))
                .foregroundColor(Color.gray.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }
}
 
// MARK: - 통계 섹션
struct StatsSection: View {
    var body: some View {
        HStack(spacing: 0) {
            StatItem(value: "42", label: "PROOFS")
            
            Rectangle()
                .fill(Color(hex: "#2C2C2E"))
                .frame(width: 1, height: 36)
 
            StatItem(value: "1.8K", label: "IMPACT")
 
            Rectangle()
                .fill(Color(hex: "#2C2C2E"))
                .frame(width: 1, height: 36)
 
            StatItem(value: "HipPop", label: "GENRE")
        }
        .padding(.vertical, 20)
        .background(Color(hex: "#161616"))
        .cornerRadius(16)
        .shadow(
            color: .purple.opacity(0.3),
            radius: 8,
            x: 4, y: 4)
        .padding(.horizontal, 20)
        .padding(.bottom, 28)
    }
}

//MARK: - 통계 텍스트
struct StatItem: View {
    let value: String
    let label: String
 
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.gray)
                .tracking(1.0)
        }
        .frame(maxWidth: .infinity)
    }
}
 
// MARK: - 피처드 영상 섹션
struct FeaturedVideoSection: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // 배경 이미지 자리
//            Rectangle()
//                .fill(
//                    LinearGradient(
//                        colors: [Color(hex: "#1A1A2E"), Color(hex: "#0D0D0D")],
//                        startPoint: .top,
//                        endPoint: .bottom
//                    )
//                )
//                .frame(maxWidth: .infinity)
//                .frame(height: 200)
//                .overlay(
//                    // 영상 배경 placeholder
//                    Image(systemName: "person.fill")
//                        .font(.system(size: 60))
//                        .foregroundColor(Color.white.opacity(0.1))
//                )
            Image("proof")
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 5)
               
 
            // 그라데이션 오버레이
            LinearGradient(
                colors: [Color.clear, Color.black.opacity(0.85)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 200)
 
            // 텍스트 + 재생버튼
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Shadows of the Unspoken")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                    Text("Featured Concept Film • 2024")
                        .font(.system(size: 12))
                        .foregroundColor(Color.gray.opacity(0.8))
                }
 
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 0))
        .padding(.bottom, 28)
    }
}
 
// MARK: - 댄스 스타일 섹션
struct DanceStylesSection: View {
    let styles = ["Contemporary", "Urban", "Lyrical", "Cinematic", "Jazz-Funk"]
    @State private var selected = "Contemporary"
 
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                // 화살표 라인
                HStack(spacing: 8) {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
 
                    Text("Dance Styles & Categories")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                }
 
                Spacer()
 
                Button(action: {}) {
                    Text("VIEW ALL")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(hex: "#BF5AF2"))
                        .tracking(0.5)
                }
            }
            .padding(.horizontal, 20)
 
            // 태그 칩들
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    ForEach(styles.prefix(3), id: \.self) { style in
                        StyleChip(label: style, isSelected: selected == style) {
                            selected = style
                        }
                    }
                }
                HStack(spacing: 10) {
                    ForEach(styles.suffix(2), id: \.self) { style in
                        StyleChip(label: style, isSelected: selected == style) {
                            selected = style
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 28)
    }
}

// MARK: - 댄스 스타일 섹션에 카테고리 버튼들
struct StyleChip: View {
    let label: String
    let isSelected: Bool
    let onTap: () -> Void
 
    var body: some View {
        Button(action: onTap) {
            Text(label)
                .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .white : Color.gray.opacity(0.8))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color(hex: "#BF5AF2") : Color(hex: "#1C1C1E"))
                )
        }
    }
}
 
// MARK: - 최근 증명 섹션
struct LatestProofsSection: View {
    let proofs: [(title: String, imageName: String)] = [
        ("Hip-Hop Flow", "proof1"),
        ("Urban Street", "proof2"),
        ("Contemporary", "proof3"),
        ("Lyrical Stage", "proof4"),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Latest Proofs")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)],
                spacing: 8
            ) {
                ForEach(proofs, id: \.title) { proof in
                    ZStack(alignment: .topTrailing) {
                        // 실제 이미지
                        Image(proof.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                        // 블록체인 인증 아이콘
                        Image(systemName: "checkmark.shield.fill")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#BF5AF2"))
                            .padding(8)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                            .padding(8)

                        // 하단 제목
                        VStack {
                            Spacer()
                            HStack {
                                Text(proof.title)
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                Spacer()
                            }
                            .background(
                                LinearGradient(
                                    colors: [Color.clear, Color.black.opacity(0.7)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .frame(height: 160)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}
 
#Preview {
    MyPageView()
}
