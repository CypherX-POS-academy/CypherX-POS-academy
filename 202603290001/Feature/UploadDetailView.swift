//
//  UploadDetailView.swift
//  202603290001
//
//  Created by Riolu on 3/31/26.
//

import SwiftUI
import Photos
 
struct UploadDetailsView: View {
    let selectedAsset: PHAsset?
 
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var thumbnail: UIImage? = nil
    @State private var isRecording = false
    @State private var isRecorded = false
    @Environment(\.dismiss) private var dismiss
 
    var body: some View {
        ZStack {
            Color(hex: "#0D0D0D").ignoresSafeArea()
 
            VStack(spacing: 0) {
                // MARK: - Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
 
                    Spacer()
 
                    Text("New Choreography")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
 
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color(hex: "#111111"))
 
                ScrollView {
                    VStack(spacing: 0) {
                        // MARK: - Title Row
                        HStack(alignment: .top, spacing: 14) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(hex: "#1C1C1E"))
                                    .frame(width: 80, height: 80)
 
                                if let img = thumbnail {
                                    ZStack(alignment: .center) {
                                        Image(uiImage: img)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .clipped()
                                            .cornerRadius(8)
 
                                        Image(systemName: "play.circle.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(.white.opacity(0.9))
                                    }
                                } else {
                                    Image(systemName: "video.fill")
                                        .font(.system(size: 28))
                                        .foregroundColor(Color(hex: "#BF5AF2").opacity(0.6))
                                }
                            }
 
                            VStack(alignment: .leading, spacing: 6) {
                                Text("TITLE")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.gray)
                                    .tracking(1.2)
 
                                TextField("Enter title...", text: $title)
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 12)
                                    .background(Color(hex: "#1C1C1E"))
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
 
                        Rectangle()
                            .fill(Color(hex: "#2C2C2E"))
                            .frame(height: 1)
                            .padding(.horizontal, 20)
 
                        // MARK: - Description
                        VStack(alignment: .leading, spacing: 10) {
                            Text("DESCRIPTION")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.gray)
                                .tracking(1.2)
 
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(hex: "#1C1C1E"))
                                    .frame(minHeight: 120)
 
                                if description.isEmpty {
                                    Text("Tell the story of this movement...")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 14)
                                        .padding(.top, 14)
                                }
 
                                TextEditor(text: $description)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.clear)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 8)
                                    .frame(minHeight: 120)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
 
                        // MARK: - Blockchain Card
                        BlockchainRegistrationCard(
                            isRecording: $isRecording,
                            isRecorded: $isRecorded,
                            title: title,          // API 전달용 파라미터 추가
                            description: description // API 전달용 파라미터 추가
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear { loadThumbnail() }
    }
 
    private func loadThumbnail() {
        guard let asset = selectedAsset else { return }
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: CGSize(width: 160, height: 160),
            contentMode: .aspectFill,
            options: options
        ) { img, _ in
            DispatchQueue.main.async { self.thumbnail = img }
        }
    }
}
 
// MARK: - Blockchain Registration Card
struct BlockchainRegistrationCard: View {
    @Binding var isRecording: Bool
    @Binding var isRecorded: Bool
    let title: String          // 외부에서 입력받을 제목
    let description: String    // 외부에서 입력받을 설명
    @State private var pulseScale: CGFloat = 1.0
 
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#BF5AF2").opacity(0.15))
                        .frame(width: 36, height: 36)
                    Image(systemName: "network")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#BF5AF2"))
                }
 
                VStack(alignment: .leading, spacing: 2) {
                    Text("BLOCKCHAIN")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.white)
                        .tracking(1.5)
                    Text("REGISTRATION")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.white)
                        .tracking(1.5)
                }
 
                Spacer()
 
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.seal.fill").font(.system(size: 11))
                    Text("VERIFIED").font(.system(size: 10, weight: .bold)).tracking(0.8)
                }
                .foregroundColor(Color(hex: "#BF5AF2"))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Capsule().stroke(Color(hex: "#BF5AF2"), lineWidth: 1.5))
            }
            .padding(.horizontal, 18)
            .padding(.top, 18)
            .padding(.bottom, 16)
 
            Rectangle().fill(Color(hex: "#2C2C2E")).frame(height: 1).padding(.horizontal, 18)
 
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("NETWORK")
                        .font(.system(size: 9, weight: .bold)).foregroundColor(.gray).tracking(1.0)
                    HStack(spacing: 6) {
                        Circle().fill(Color.green).frame(width: 7, height: 7)
                        Text("Solana Devnet").font(.system(size: 13, weight: .medium)).foregroundColor(.white)
                    }
                }
                Spacer()
                Rectangle().fill(Color(hex: "#2C2C2E")).frame(width: 1, height: 40)
                Spacer()
                VStack(alignment: .leading, spacing: 6) {
                    Text("LICENSE TYPE")
                        .font(.system(size: 9, weight: .bold)).foregroundColor(.gray).tracking(1.0)
                    HStack(spacing: 6) {
                        Image(systemName: "c.circle").font(.system(size: 12)).foregroundColor(.gray)
                        Text("Creative\nCommons").font(.system(size: 13, weight: .medium)).foregroundColor(.white).lineLimit(2)
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
 
            Rectangle().fill(Color(hex: "#2C2C2E")).frame(height: 1).padding(.horizontal, 18)
 
            HStack {
                Text("Estimated Transaction Fee").font(.system(size: 13)).foregroundColor(.gray)
                Spacer()
                Text("~0.000005 SOL").font(.system(size: 13, weight: .semibold)).foregroundColor(Color(hex: "#BF5AF2"))
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
 
            Button(action: {
                // 1. 민팅 시작 -> UI 업데이트 (Loading)
                withAnimation(.spring()) { isRecording = true }
                
                // 2. 비동기 블록(Task) 시작: 외부 API 호출하기
                Task {
                    do {
                        // CrossmintAPI 싱글톤을 이용해 POST 민팅 요청
                        let transactionURL = try await CrossmintAPI.shared.mintChoreographyNFT(
                            title: title, 
                            description: description
                        )
                        
                        // 3. 메인 스레드로 돌아와서 성공 상태 업데이트
                        await MainActor.run {
                            withAnimation(.spring()) { 
                                isRecording = false
                                isRecorded = true 
                            }
                            
                            // 4. (보너스) 성공 애니메이션 잠시 본 후 Safari 브라우저에서 결과 창 오픈!
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                if let url = URL(string: transactionURL) {
                                    UIApplication.shared.open(url)
                                }
                            }
                        }
                    } catch {
                        // 5. 에러 시 로딩 풀기 (MVP용 간단한 콘솔 출력)
                        print("Blockchain API Minting Error: \(error)")
                        await MainActor.run {
                            withAnimation(.spring()) { isRecording = false }
                        }
                    }
                }
            }) {
                HStack(spacing: 10) {
                    if isRecording {
                        ProgressView().tint(.white).scaleEffect(0.85)
                    } else if isRecorded {
                        Image(systemName: "checkmark.shield.fill").font(.system(size: 17))
                    } else {
                        Image(systemName: "shield.fill").font(.system(size: 17))
                    }
                    Text(isRecording ? "Recording..." : isRecorded ? "Recorded on Blockchain" : "Record on Blockchain")
                        .font(.system(size: 16, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            isRecorded
                                ? LinearGradient(colors: [Color(hex: "#2ECC71"), Color(hex: "#27AE60")], startPoint: .leading, endPoint: .trailing)
                                : LinearGradient(colors: [Color(hex: "#BF5AF2"), Color(hex: "#9B59B6")], startPoint: .leading, endPoint: .trailing)
                        )
                )
            }
            .disabled(isRecording || isRecorded)
            .padding(.horizontal, 18)
            .padding(.top, 4)
            .padding(.bottom, 14)
 
            Text("By recording, you anchor this choreography's metadata\nto the Solana ledger, creating an immutable proof of\ncreation for your digital IP.")
                .font(.system(size: 11))
                .foregroundColor(Color.gray.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 18)
                .padding(.bottom, 18)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "#1A1A1A"))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "#2C2C2E"), lineWidth: 1))
        )
    }
}
