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
            videoUrl: "asset://HipHopVideo",
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
            genre: "Contemporary",
            videoUrl: "asset://ContemporaryVideo",
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
            genre: "Popping",
            videoUrl: "asset://PoppingVideo",
            hash: "2x41lkop12m...0wlz77kqp",
            explorerUrl: "https://explorer.solana.com/address/9QweRTY789asdfghjkl",
            createdAt: "2026-03-30",
            solanaWalletAddress: "9QweRTY789asdfghjklZXCVbnm1234567890abcd"
        ),
        Choreography(
            id: "tx4",
            name: "@maverick",
            profileImage: "artistProfile2",
            title: "Jazz Fusion Motion",
            description: "A jazz-inspired choreography blending fluid transitions with dynamic musicality.",
            genre: "Jazz",
            videoUrl: "asset://JazzVideo",
            hash: "9b3c10cf88q...1x9r99xzpq",
            explorerUrl: "https://explorer.solana.com/address/AbC123SolanaXYZ",
            createdAt: "2026-03-29",
            solanaWalletAddress: "AbC123SolanaXYZ987654321mnopQRSTuvwxy"
        ),
        Choreography(
            id: "tx5",
            name: "@riolu",
            profileImage: "artistProfile1",
            title: "Locking Funk Session",
            description: "A funky locking routine full of groove, character, and rhythmic accents.",
            genre: "Locking",
            videoUrl: "asset://LockingVideo",
            hash: "2x41lkop12m...0wlz77kqp",
            explorerUrl: "https://explorer.solana.com/address/Zyx987SolWallet",
            createdAt: "2026-03-30",
            solanaWalletAddress: "Zyx987SolWalletABCDE123456789fghijklmnop"
        ),
        Choreography(
            id: "tx6",
            name: "@rossi",
            profileImage: "artistProfile2",
            title: "House Dance Vibes",
            description: "A high-energy house dance choreography emphasizing footwork and rhythm.",
            genre: "House",
            videoUrl: "asset://HouseVideo",
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
    @State private var isVideoVisible = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if let url = VideoAssetURLResolver.resolve(item.videoUrl) {
                LoopingPlayerView(url: url, isPlaying: isVideoVisible)
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
        .onScrollVisibilityChange(threshold: 0.95) { isVisible in
            isVideoVisible = isVisible
        }
    }
    
    func shortAddress(_ address: String) -> String {
        let start = address.prefix(4)
        let end = address.suffix(4)
        return "\(start)...\(end)"
    }
}

enum VideoAssetURLResolver {
    private static let assetScheme = "asset://"
    
    static func resolve(_ source: String) -> URL? {
        if source.hasPrefix(assetScheme) {
            let assetName = String(source.dropFirst(assetScheme.count))
            return localAssetURL(named: assetName)
        }
        
        return URL(string: source)
    }
    
    private static func localAssetURL(named assetName: String) -> URL? {
        guard let asset = NSDataAsset(name: assetName) else {
            return nil
        }
        
        let fileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(assetName)
            .appendingPathExtension("mp4")
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try asset.data.write(to: fileURL, options: .atomic)
            } catch {
                return nil
            }
        }
        
        return fileURL
    }
}

// 자동 반복 재생을 위한 AVFoundation 기반 비디오 플레이어 (커스텀 뷰)
struct LoopingPlayerView: UIViewRepresentable {
    let url: URL
    let isPlaying: Bool
    
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
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Safe Layout 업데이트
        DispatchQueue.main.async {
            if let layer = uiView.layer.sublayers?.first(where: { $0 is AVPlayerLayer }) {
                layer.frame = uiView.bounds
            }
        }

        if isPlaying {
            context.coordinator.player?.play()
        } else {
            context.coordinator.player?.pause()
        }
    }

    static func dismantleUIView(_ uiView: UIView, coordinator: Coordinator) {
        coordinator.player?.pause()
        coordinator.player?.removeAllItems()
        coordinator.looper = nil
    }
}

#Preview {
    ListView()
}
