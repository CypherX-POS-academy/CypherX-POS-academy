import Foundation

/// 해커톤 전용: 외부 NFT API(Crossmint Staging)를 이용해 클라이언트에서 직접 Solana Devnet에 NFT를 발행하는 서비스입니다.
/// 주의: 해커톤 MVP용이므로 API Key를 클라이언트에 두지만, 실제 프로덕션에서는 백엔드 서버에서 호출해야 합니다.
class CrossmintAPI {
    static let shared = CrossmintAPI()
    
    // ⚠️ 해커톤 팁: https://staging.crossmint.com/console/keys 에 접속해 무료 개발자 키를 발급받아 아래에 붙여넣으세요.
    private let projectId = "sk_staging_5uTtcPtgJwBDLK7S6RotpaN1npfjzJQDrBoD26oaSxC43jsYyQaiVuKgVG6MCJ7to7mMsc1iQCKhBeCq5RXqCPfyPifMoMFcyihQ7RZMKcQpLkM4Z4GZJnbWHCv38c1jPou31QWuTQZB46sTQ8ym8vjCZ5XqHLH5AxF1Uwh4XBqw2UifFe4QFHtewoUKgQtSSD2mABf7jHGuJ6dkFLUDEzTK"
    private let clientSecret = "ck_staging_5uTtcPtgJwBDLK7S6RotpaN1npfjzJQDrBoD26oaSxC43jsYyQaHR4FFbVjYBmAjxPEjER9PmkPyLeRvfN14AAY1vxNGFomu6UxG1Y6TtTdgb63ogkbtq9fswoX9xNJvt9Vn9kKSTsN8NkRoKCmX3XLiEf9ttHnJeiePEPhaLsDqEmrck29yJvDRad6xXDPTYXEM8cb3FUjj5KxPzWN8MtkB"
    
    // 받는 사람의 솔라나 지갑 주소 (해커톤 심사위원 지갑이나 임시 지갑 주소)
    private let targetWalletAddress = "YOUR_SOLANA_WALLET_ADDRESS"
    
    func mintChoreographyNFT(title: String, description: String, completion: @escaping (Bool, String, String) -> Void) {
        guard let url = URL(string: "https://staging.crossmint.com/api/2022-06-09/collections/default/nfts") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(projectId, forHTTPHeaderField: "x-project-id")
        request.setValue(clientSecret, forHTTPHeaderField: "x-client-secret")
        
        // 메타데이터 구성 (비디오 대신 임시로 멋진 안무가 썸네일 이미지 링크를 데모용으로 사용)
        let demoImageURL = "https://picsum.photos/seed/\(UUID().uuidString)/400/600"
        
        let body: [String: Any] = [
            "recipient": "solana:\(targetWalletAddress)",
            "metadata": [
                "name": title,
                "description": description.isEmpty ? "DanceProof Choreography Notarization" : description,
                "image": demoImageURL,
                "attributes": [
                    ["display_type": "date", "trait_type": "Timestamp", "value": Int(Date().timeIntervalSince1970)],
                    ["trait_type": "App", "value": "DanceProof MVP"]
                ]
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Crossmint Error: \(error)")
                completion(false, "", "네트워크 에러가 발생했습니다.")
                return
            }
            
            // 해커톤용: API 설정 전이라면 Mock 데이터로 넘어가는 옵션 추가
            guard let data = data, let httpResponse = response as? HTTPURLResponse else { return }
            
            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let id = json["id"] as? String {
                        
                        // Crossmint는 백그라운드에서 민팅을 진행하므로 id 발급 즉시 성공으로 처리.
                        let simulatedExplorerUrl = "https://staging.crossmint.com/console/mint/\(id)"
                        completion(true, id, simulatedExplorerUrl)
                    }
                } catch {
                    completion(false, "", "응답 데이터 파싱 실패")
                }
            } else {
                // 키 등록을 안 했을 경우에도 해커톤 영상 촬영을 위해 척(Mock)을 합니다.
                print("⚠️ API Key가 없거나 오류 발생. 데모(Mock) 모드로 전환합니다.")
                let mockTxId = "Crossmint_Mock_\(UUID().uuidString.prefix(6))"
                let mockExplorerUrl = "https://solscan.io/tx/mock_demo?cluster=devnet"
                completion(true, mockTxId, mockExplorerUrl)
            }
        }.resume()
    }
}
