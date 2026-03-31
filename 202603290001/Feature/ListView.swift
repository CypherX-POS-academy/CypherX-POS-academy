import SwiftUI
import AVFoundation

struct ListView: View {

    // 임시 Mock 데이터
    let mockData: [Choreography] = [
        Choreography(
            id: "tx1",
            name: "@miro",
            profileImage: "artistProfile1",
            title: "Hip Hop Groove",
            description: "A hip-hop groove set to powerful beats, focusing on isolation techniques.",
            genre: "Hip Hop",
            videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
            hash: "8xdfa9c82b1...39abc1234f",
            explorerUrl: "https://explorer.solana.com/address/4XH9abcDEF123456789",
            createdAt: "2026-03-29",
            solanaWalletAddress: "4XH9abcDEF123456789GhijkLmnoPQRstuVWXYZ"
        ),
        Choreography(
            id: "tx2",
            name: "@neon",
            profileImage: "artistProfile2",
            title: "Contemporary Flow",
            description: "A contemporary dance piece highlighting expressive emotion and floor work.",
            genre: "Choreography",
            videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
            hash: "9b3c10cf88q...1x9r99xzpq",
            explorerUrl: "https://explorer.solana.com/address/7YkLmn456XYZabcdef",
            createdAt: "2026-03-29",
            solanaWalletAddress: "7YkLmn456XYZabcdef12345GhijkLMNOPqrstuv"
        ),
        Choreography(
            id: "tx3",
            name: "@mugu",
            profileImage: "artistProfile1",
            title: "Urban Popping",
            description: "An urban popping freestyle session blending smoothness with sharp precision.",
            genre: "Street",
            videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
            hash: "2x41lkop12m...0wlz77kqp",
            explorerUrl: "https://explorer.solana.com/address/9QweRTY789asdfghjkl",
            createdAt: "2026-03-30",
            solanaWalletAddress: "9QweRTY789asdfghjklZXCVbnm1234567890abcd"
        ),
        Choreography(
            id: "tx4",
            name: "@meverick",
            profileImage: "artistProfile2",
            title: "Contemporary Flow",
            description: "A contemporary dance piece highlighting expressive emotion and floor work.",
            genre: "Choreography",
            videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
            hash: "9b3c10cf88q...1x9r99xzpq",
            explorerUrl: "https://explorer.solana.com/address/AbC123SolanaXYZ",
            createdAt: "2026-03-29",
            solanaWalletAddress: "AbC123SolanaXYZ987654321mnopQRSTuvwxy"
        ),
        Choreography(
            id: "tx5",
            name: "@riolu",
            profileImage: "artistProfile1",
            title: "Urban Popping",
            description: "An urban popping freestyle session blending smoothness with sharp precision.",
            genre: "Street",
            videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
            hash: "2x41lkop12m...0wlz77kqp",
            explorerUrl: "https://explorer.solana.com/address/Zyx987SolWallet",
            createdAt: "2026-03-30",
            solanaWalletAddress: "Zyx987SolWalletABCDE123456789fghijklmnop"
        ),
        Choreography(
            id: "tx6",
            name: "@rossi",
            profileImage: "artistProfile2",
            title: "Hip Hop Groove",
            description: "A hip-hop groove set to powerful beats, focusing on isolation techniques.",
            genre: "Hip Hop",
            videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
            hash: "8xdfa9c82b1...39abc1234f",
            explorerUrl: "https://explorer.solana.com/address/SolAddr999XYZ",
            createdAt: "2026-03-29",
            solanaWalletAddress: "SolAddr999XYZabcdefghijk123456789LMNOPQR"
        )
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.edgesIgnoringSafeArea(.all)
            
            HStack {
                Spacer()
                Image("SearchButton")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .padding(.trailing, 24)
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(mockData) { item in
                        TiktokCardView(item: item)
                            .containerRelativeFrame([.horizontal, .vertical])
                    }
                }
            }
            .scrollTargetBehavior(.paging)
            .ignoresSafeArea(.all)
        }
    }
}

struct TiktokCardView: View {
    let item: Choreography
    
    var body: some View {
        FrontVideoView(item: item)
    }
}

struct FrontVideoView: View {
    let item: Choreography
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if let url = URL(string: item.videoUrl) {
                LoopingPlayerView(url: url)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Color.black.edgesIgnoringSafeArea(.all)
            }
            
            VStack {
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(item.name)
                            .font(.title)
                            .bold()
                        
                        Text(item.title)
                            .font(.title3)
                            .bold()
                        
                        if let desc = item.description, !desc.isEmpty {
                            Text(desc)
                                .font(.subheadline)
                                .lineLimit(2)
                        }
                    }
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    VStack(spacing: 24) {
                        Image(item.profileImage)
                            .resizable()
                            .frame(width: 48, height: 48)
                            .cornerRadius(24)
                        
                        VStack(spacing: 4) {
                            Image("FilledProofButton")
                            
                            Text("PROOF")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundStyle(.primary300)
                        }
                    }
                }
                
                Divider()
                    .background(Color.gray)
                    .padding(.top, 21)
                    .padding(.bottom, 12)
                
                HStack(spacing: 6) {
                    Image("walletVerificationIcon")
                        .resizable()
                        .frame(width: 11, height: 11)
                    
                    Text("Verified on Solana • \(shortAddress(item.solanaWalletAddress))")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.gray)
                    
                    Spacer()
                    
                    Image("ShareButton1")
                        .resizable()
                        .frame(width: 9, height: 9)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100)

        }
    }
    
    func shortAddress(_ address: String) -> String {
        let start = address.prefix(4)
        let end = address.suffix(4)
        return "\(start)...\(end)"
    }
}

// 자동 반복 재생을 위한 AVFoundation 기반 비디오 플레이어 (커스텀 뷰)
struct LoopingPlayerView: UIViewRepresentable {
    let url: URL
    
    class Coordinator {
        var player: AVQueuePlayer?
        var looper: AVPlayerLooper?
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let playerItem = AVPlayerItem(url: url)
        let player = AVQueuePlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        
        let looper = AVPlayerLooper(player: player, templateItem: playerItem)
        
        context.coordinator.player = player
        context.coordinator.looper = looper
        
        player.play()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Safe Layout 업데이트
        DispatchQueue.main.async {
            if let layer = uiView.layer.sublayers?.first(where: { $0 is AVPlayerLayer }) {
                layer.frame = uiView.bounds
            }
        }
    }
}

#Preview {
    ListView()
}
