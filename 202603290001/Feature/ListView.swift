import SwiftUI
import AVKit
import AVFoundation
import WebKit

struct ListView: View {

    // 임시 Mock 데이터
    let mockData: [Choreography] = [
        Choreography(
            id: "tx1",
            title: "Hip Hop Groove",
            description: "A hip-hop groove set to powerful beats, focusing on isolation techniques.",
            genre: "Hip Hop",
            videoUrl: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
            hash: "8xdfa9c82b1...39abc1234f",
            explorerUrl: "https://explorer.solana.com/",
            createdAt: "2026-03-29"
        ),
        Choreography(
            id: "tx2",
            title: "Contemporary Flow",
            description: "A contemporary dance piece highlighting expressive emotion and floor work.",
            genre: "Choreography",
            videoUrl: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
            hash: "9b3c10cf88q...1x9r99xzpq",
            explorerUrl: "https://explorer.solana.com/",
            createdAt: "2026-03-29"
        ),
        Choreography(
            id: "tx3",
            title: "Urban Popping",
            description: "An urban popping freestyle session blending smoothness with sharp precision.",
            genre: "Street",
            videoUrl: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
            hash: "2x41lkop12m...0wlz77kqp",
            explorerUrl: "https://explorer.solana.com/",
            createdAt: "2026-03-30"
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
    @State private var isFlipped = false
    
    var body: some View {
        ZStack {
            if isFlipped {
                BackLogicView(item: item, isFlipped: $isFlipped)
                    // 회전했을 때 뒷면 글씨가 거울처럼 반전되지 않도록 Y축으로 180도 미리 돌려둡니다.
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            } else {
                FrontVideoView(item: item, isFlipped: $isFlipped)
            }
        }
        // 버튼을 누를 때 3D 회전 애니메이션 실행
        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0), value: isFlipped)
    }
}

struct FrontVideoView: View {
    let item: Choreography
    @Binding var isFlipped: Bool
    @State private var isShowingPayment = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // 배경 비디오 재생
            if let url = URL(string: item.videoUrl) {
                LoopingPlayerView(url: url)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Color.black.edgesIgnoringSafeArea(.all)
            }
            
            // 정보 및 액션 오버레이
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(item.title)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    
                    if let desc = item.description, !desc.isEmpty {
                        Text(desc)
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .shadow(radius: 5)
                    }
                }
                Spacer()
                
                VStack(spacing: 20) {
                    // 결제 / 소유권 구매 버튼
                    Button(action: { isShowingPayment = true }) {
                        VStack(spacing: 5) {
                            Image(systemName: "bitcoinsign.circle.fill")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .foregroundColor(.yellow)
                            Text("Buy")
                                .font(.caption)
                                .bold()
                        }
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    }
                    
                    // 뒤집기 버튼 (자세한 로직 보기)
                    Button(action: { isFlipped.toggle() }) {
                        VStack(spacing: 5) {
                            Image(systemName: "cube.transparent")
                                .resizable()
                                .frame(width: 35, height: 35)
                            Text("Logic")
                                .font(.caption)
                                .bold()
                        }
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    }
                }
                .padding(.bottom, 20) // 탭바 영역 고려
            }
            .padding()
            .padding(.bottom, 100) // 하단 탭바 겹침 방지 여백 추가
        }
        .sheet(isPresented: $isShowingPayment) {
            PaymentWebView(url: URL(string: "https://solscan.io/tx/\(item.hash)")!)
        }
    }
}

struct BackLogicView: View {
    let item: Choreography
    @Binding var isFlipped: Bool
    
    var body: some View {
        ZStack {
            Color(white: 0.1).ignoresSafeArea() // 다크 배경
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // 글로벌 검색/필터 바 영역 회피를 위한 상단 여백 (레이아웃 겹침 방지)
                    Spacer()
                        .frame(height: 180)
                    
                    HStack {
                        Text("Dance Logic & Verified Data")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                        Button(action: { isFlipped.toggle() }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    if let desc = item.description, !desc.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Choreography Details")
                                .font(.headline)
                                .foregroundColor(.purple)
                            Text(desc)
                                .foregroundColor(.white)
                                .font(.body)
                        }
                    }
                    
                    Divider()
                    
                    // 블록체인 검증 데이터 (해시값 등)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("SHA-256 Hash Fileprint")
                            .font(.headline)
                            .foregroundColor(.green)
                        Text(item.hash)
                            .font(.system(size: 13, design: .monospaced))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                    }
                    
                    Spacer(minLength: 50)
                    
                    if let explorerUrl = URL(string: item.explorerUrl) {
                        Link(destination: explorerUrl) {
                            HStack {
                                Image(systemName: "link")
                                Text("View on Solana Explorer")
                                    .bold()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                        }
                        .padding(.bottom, 60)
                    }
                }
                .padding(.horizontal, 25)
            }
        }
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

// WKWebView를 통해 Solscan 등 결제 창을 띄워주는 인앱 모달 컴포넌트
struct PaymentWebView: View {
    let url: URL
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            SafariWebView(url: url)
                .navigationTitle("Buy Ownership (Demo)")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
        }
    }
}

struct SafariWebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

#Preview {
    ListView()
}
