import SwiftUI
import PhotosUI
import AVKit

struct UploadView: View {
    @StateObject private var networkManager = NetworkManager()
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var videoURL: URL? = nil
    @State private var isPickerPresented = false
    
    @State private var isProcessing = false
    @State private var txId = ""
    @State private var explorerUrl = ""
    @State private var errorMessage = ""
    
    @State private var isShowingMinting = false
    
    var body: some View {
        ZStack {
            // 프리미엄 다크 모드 배경 (프로덕트 느낌)
            LinearGradient(gradient: Gradient(colors: [Color.black, Color(white: 0.1)]),
                           startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 25) {
                    Text("Mint your Move")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    Text("안무를 블록체인에 영구 기록하여 소유권을 증명하세요.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Glassmorphism 입력 폼 묶음
                    VStack(spacing: 25) {
                        // 1. 제목 입력 및 샘플
                        VStack(alignment: .leading, spacing: 10) {
                            TextField("안무 제목", text: $title)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .colorScheme(.dark)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(["안무 창작", "무용 콩쿠르", "가요 커버", "코레오그래피", "프리스타일"], id: \.self) { sample in
                                        Button(action: {
                                            title = sample
                                        }) {
                                            Text(sample)
                                                .font(.caption2)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 6)
                                                .background(Color.white.opacity(0.2))
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                            }
                        }
                        
                        // 2. 설명 입력 및 태그
                        VStack(alignment: .leading, spacing: 10) {
                            TextField("간단한 설명 (태그를 눌러 추가해보세요)", text: $description)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .colorScheme(.dark)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(["#코레오", "#힙합", "#스트릿", "#방송댄스", "#솔로루틴", "#창작안무", "#퍼포먼스"], id: \.self) { tag in
                                        Button(action: {
                                            if description.isEmpty {
                                                description = tag
                                            } else {
                                                description += " " + tag
                                            }
                                        }) {
                                            Text(tag)
                                                .font(.caption)
                                                .fontWeight(.medium)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                                .background(Color.white.opacity(0.15))
                                                .foregroundColor(.white)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                                )
                                                .cornerRadius(20)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                    
                    // 파일 선택 영역
                    VStack {
                        if let url = videoURL {
                            VStack(spacing: 15) {
                                // 썸네일/재생이 가능한 미니 다이내믹 플레이어
                                VideoPlayer(player: AVPlayer(url: url))
                                    .frame(height: 220)
                                    .cornerRadius(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("비디오 업로드 준비 완료")
                                        .foregroundColor(.green)
                                        .font(.subheadline)
                                    Spacer()
                                    
                                    Button(action: {
                                        videoURL = nil
                                        selectedItem = nil
                                    }) {
                                        Text("삭제")
                                            .font(.subheadline)
                                            .padding(.horizontal, 12).padding(.vertical, 6)
                                            .background(Color.red.opacity(0.8))
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                                    
                                    Button(action: { isPickerPresented = true }) {
                                        Text("다시 선택")
                                            .font(.subheadline)
                                            .padding(.horizontal, 12).padding(.vertical, 6)
                                            .background(Color.white.opacity(0.1))
                                            .foregroundColor(.blue)
                                            .cornerRadius(8)
                                    }
                                }
                                .padding(.horizontal, 5)
                            }
                        } else {
                            Button(action: { isPickerPresented = true }) {
                                VStack {
                                    Image(systemName: "film.fill")
                                        .font(.system(size: 40))
                                    Text("앨범에서 영상 선택")
                                        .padding(.top, 5)
                                }
                                .frame(maxWidth: .infinity, minHeight: 120)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.gray.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [10]))
                                )
                                .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .photosPicker(isPresented: $isPickerPresented, selection: $selectedItem, matching: .videos)
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let item = newItem {
                                // 임시 디렉토리로 동영상 로드
                                if let url = try? await item.loadTransferable(type: VideoTransferable.self)?.url {
                                    DispatchQueue.main.async {
                                        self.videoURL = url
                                    }
                                }
                            }
                        }
                    }
                    
                    Button(action: startMinting) {
                        Text("블록체인 기록 개시 (Mint)")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(colors: isProcessing ? [.gray, .gray] : [.blue, .purple], startPoint: .leading, endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(color: isProcessing ? .clear : .purple.opacity(0.5), radius: 10, x: 0, y: 5)
                    }
                    .disabled(isProcessing)
                    .padding(.horizontal)
                    
                    // 결과 메시지 영역
                    if !errorMessage.isEmpty {
                        Text(errorMessage).foregroundColor(.red).padding()
                    }
                    
                    if !explorerUrl.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Validation Success!").foregroundColor(.green)
                            
                            if let safariUrl = URL(string: explorerUrl) {
                                Link(destination: safariUrl) {
                                    HStack {
                                        Image(systemName: "link.circle.fill")
                                        Text("솔라나 원장 확인")
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(10)
                                    .foregroundColor(.cyan)
                                }
                            }
                        }
                        .padding(.top, 20)
                    }
                    
                    Spacer(minLength: 50)
                }
            }
            
            if isShowingMinting {
                MintingProgressView(isVisible: $isShowingMinting)
            }
        }
    }
    
    func startMinting() {
        // 비어있는 경우 시각적 경고
        guard !title.isEmpty else {
            errorMessage = "⚠️ 안무 제목을 입력해주세요."
            return
        }
        guard let url = videoURL else {
            errorMessage = "⚠️ 블록체인에 영구 기록할 영상을 첨부해주세요."
            return
        }
        
        isProcessing = true
        errorMessage = ""
        txId = ""
        explorerUrl = ""
        
        // 애니메이션 뷰 오버레이 ON
        isShowingMinting = true
        
        let creatorAddr = "user_wallet_8899"
        
        // MVP 데모를 위해 서버 통신을 바이패스하고 가상(Mock) 딜레이 후 성공 처리합니다.
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.isProcessing = false
            
            // 임의의 Mock 트랜잭션 데이터 생성
            self.txId = "5YVdjd... " + UUID().uuidString.prefix(6)
            self.explorerUrl = "https://solscan.io/tx/demo"
            
            // 성공 후 1.5초 뒤에 멘트 확인 끝내고 애니메이션 뷰 오프 및 초기화
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    self.isShowingMinting = false
                }
                self.title = ""
                self.description = ""
                self.videoURL = nil
                self.selectedItem = nil
            }
        }
    }
}

// PhotosPicker에서 비디오 임시 URL을 가져오기 위한 유틸
struct VideoTransferable: Transferable {
    let url: URL
    
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { movie in
            SentTransferredFile(movie.url)
        } importing: { received in
            let copy = URL(fileURLWithPath: NSTemporaryDirectory() + received.file.lastPathComponent)
            if FileManager.default.fileExists(atPath: copy.path) {
                try FileManager.default.removeItem(at: copy)
            }
            try FileManager.default.copyItem(at: received.file, to: copy)
            return VideoTransferable(url: copy)
        }
    }
}
