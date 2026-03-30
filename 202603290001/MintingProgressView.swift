import SwiftUI

struct MintingProgressView: View {
    @Binding var isVisible: Bool
    @State private var phase = 0
    @State private var hashString = ""
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.85)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("블록체인 민팅 프로세스")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding(.bottom, 20)
                
                if phase >= 1 {
                    HStack {
                        Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                        Text("1. 영상에서 지문(Hash) 추출 완료").foregroundColor(.white)
                    }
                    Text(hashString)
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(.green.opacity(0.7))
                        .padding(.leading, 30)
                }
                
                if phase >= 2 {
                    HStack {
                        Image(systemName: "network").foregroundColor(.blue)
                        Text("2. Solana Devnet 네트워크 접속").foregroundColor(.white)
                    }
                }
                
                if phase >= 3 {
                    HStack {
                        Image(systemName: "cpu").foregroundColor(.purple)
                        Text("3. 합의 알고리즘 계산 및 타임스탬프 기록").foregroundColor(.white)
                    }
                }
                
                if phase >= 4 {
                    HStack {
                        Image(systemName: "cube.box.fill").foregroundColor(.yellow)
                        Text("4. 원장 저장 완료 및 서명 발급!").foregroundColor(.white)
                    }
                    .padding(.top, 20)
                }
                
                Spacer()
                
                if phase < 4 {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .green))
                            .scaleEffect(1.5)
                        Spacer()
                    }
                    .padding(.bottom, 50)
                }
            }
            .padding(40)
            .background(Color.black)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.green.opacity(0.5), lineWidth: 1)
            )
            .padding(.horizontal, 20)
            .onAppear {
                startAnimation()
            }
        }
    }
    
    func startAnimation() {
        phase = 0
        // Generate random fake hash just for visual effect before real one arrives
        hashString = UUID().uuidString.replacingOccurrences(of: "-", with: "") + UUID().uuidString.replacingOccurrences(of: "-", with: "")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation { phase = 1 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation { phase = 2 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation { phase = 3 }
        }
        // Step 4 will be triggered when the server responds
    }
    
    // 이 함수는 외부(UploadView)에서 서버 응답을 받았을 때 호출합니다.
    func completeProcess() {
        withAnimation { phase = 4 }
    }
}
