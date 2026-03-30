import SwiftUI
import AVKit
import AVFoundation
import WebKit

struct ListView: View {
    // 서버 오류를 대비/테스트하기 위한 임시 목업 데이터
    let mockData: [Choreography] = [
        Choreography(id: "tx1", title: "Hip Hop Groove", description: "강렬한 비트에 맞춘 힙합 그루브. 아이솔레이션을 위주로 구성된 안무입니다.", genre: "힙합", videoUrl: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4", hash: "8xdfa9c82b1...39abc1234f", explorerUrl: "https://explorer.solana.com/", createdAt: "2026-03-29"),
        Choreography(id: "tx2", title: "Contemporary Flow", description: "플로어 워크와 감정선이 돋보이는 현대무용 작품.", genre: "코레오", videoUrl: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", hash: "9b3c10cf88q...1x9r99xzpq", explorerUrl: "https://explorer.solana.com/", createdAt: "2026-03-29"),
        Choreography(id: "tx3", title: "Urban Popping", description: "부드러움과 절도가 공존하는 어반 팝핑 프리스타일 세션.", genre: "스트릿", videoUrl: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4", hash: "2x41lkop12m...0wlz77kqp", explorerUrl: "https://explorer.solana.com/", createdAt: "2026-03-30")
    ]
    
    @State private var searchText = ""
    @State private var selectedGenre = "All"
    let genres = ["All", "힙합", "코레오", "스트릿", "방송댄스"]
    
    var filteredData: [Choreography] {
        mockData.filter { item in
            let matchSearch = searchText.isEmpty || item.title.localizedCaseInsensitiveContains(searchText) || (item.description?.localizedCaseInsensitiveContains(searchText) ?? false)
            let matchGenre = selectedGenre == "All" || item.genre == selectedGenre
            return matchSearch && matchGenre
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.edgesIgnoringSafeArea(.all)
            
            // 배경 비디오 스크롤 뷰 (필터링된 데이터 사용)
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    if filteredData.isEmpty {
                        Text("조건에 맞는 안무가 없습니다.")
                            .foregroundColor(.gray)
                            .frame(maxHeight: .infinity)
                            .padding(.top, 200)
                    } else {
                        ForEach(filteredData) { item in
                            TiktokCardView(item: item)
                                .containerRelativeFrame([.horizontal, .vertical])
                        }
                    }
                }
            }
            .scrollTargetBehavior(.paging)
            .ignoresSafeArea(.all)
            
            // 상단 검색 및 칩(Chips) 필터 오버레이
            VStack(spacing: 15) {
                // 검색 바
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("안무, 해시태그 검색...", text: $searchText)
                        .foregroundColor(.white)
                }
                .padding(12)
                .background(Color.white.opacity(0.15))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // 장르 선택 스크롤 뷰 (검색어가 없을 때만 표시)
                if searchText.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(genres, id: \.self) { genre in
                                Button(action: {
                                    withAnimation {
                                        selectedGenre = genre
                                    }
                                }) {
                                    Text(genre)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 18)
                                        .padding(.vertical, 8)
                                        .background(selectedGenre == genre ? Color.purple : Color.white.opacity(0.1))
                                        .foregroundColor(.white)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                    }
                }
            }
            // 탭바 및 상단 노치 회피/시인성 향상을 위한 그라데이션과 다이내믹 포지션
            .padding(.top, 10)
            .background(
                LinearGradient(colors: [.black.opacity(0.8), .clear], startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.top)
            )
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
