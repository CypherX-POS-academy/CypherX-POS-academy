import SwiftUI
import PhotosUI

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
                    
                    // Glassmorphism 입력 폼
                    VStack(spacing: 15) {
                        TextField("안무 제목", text: $title)
                        TextField("간단한 설명", text: $description)
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(15)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .colorScheme(.dark)
                    .padding(.horizontal)
                    
                    // 파일 선택 영역
                    VStack {
                        if let url = videoURL {
                            Text("비디오 선택 완료: \(url.lastPathComponent)")
                                .foregroundColor(.green)
                            
                            Button("다시 선택") { isPickerPresented = true }
                                .padding(.top, 5)
                                .foregroundColor(.blue)
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
                                LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 5)
                    }
                    .disabled(isProcessing || title.isEmpty || videoURL == nil)
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
        guard let url = videoURL else { return }
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
