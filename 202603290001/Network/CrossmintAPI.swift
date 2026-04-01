//
//  CrossmintAPI.swift
//  202603290001
//

import Foundation

class CrossmintAPI {
    static let shared = CrossmintAPI()
    
    // MARK: - Constants
    // TODO: Crossmint 대시보드에서 발급받은 실제 값으로 교체하세요.
    private let projectId = "61e6ef63-1a8f-4920-b424-20684ca469e0"
    private let clientSecret = "sk_staging_5uTtcPtgJwBDLK7S6RotpaN1npfjzJQDrBoD26oaSxC43jsYyQaiVuKgVG6MCJ7to7mMsc1iQCKhBeCq5RXqCPfyPifMoMFcyihQ7RZMKcQpLkM4Z4GZJnbWHCv38c1jPou31QWuTQZB46sTQ8ym8vjCZ5XqHLH5AxF1Uwh4XBqw2UifFe4QFHtewoUKgQtSSD2mABf7jHGuJ6dkFLUDEzTK"
    // 민팅받을 솔라나 지갑 주소 명시 (예: "solana:YOUR_WALLET_ADDRESS")
    // 이메일 수신이라면 "email:youremail@example.com:solana" 등을 사용할 수 있습니다.
    private let recipientAddress = "solana:GN1wbYc5ZjfPftvCFWKhxf1eTpMa3EuKx2qXPmB5xqNE"
    
    private init() {}
    
    // MARK: - Mint Action
    /// 솔라나 Devnet에 안무 메타데이터를 담은 NFT를 민팅합니다.
    /// 반환값: 민팅 성공 시 확인할 수 있는 트랜잭션/대시보드 URL (String)
    func mintChoreographyNFT(title: String, description: String) async throws -> String {
        guard let url = URL(string: "https://staging.crossmint.com/api/2022-06-09/collections/default/nfts") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Crossmint API 인증 헤더 추가
        request.setValue(projectId, forHTTPHeaderField: "x-project-id")
        request.setValue(clientSecret, forHTTPHeaderField: "x-client-secret")
        
        // 민팅 바디 JSON 세팅
        let safeTitle = title.isEmpty ? "Untitled Choreography" : title
        let safeDesc = description.isEmpty ? "A dynamic new choreography registered on the Solana blockchain." : description
        
        let metadata: [String: Any] = [
            "name": safeTitle,
            "description": safeDesc,
            "image": "https://www.crossmint.com/assets/crossmint/logo.png" // 해커톤 MVP용 임시 이미지 URL
        ]
        
        let body: [String: Any] = [
            "recipient": recipientAddress,
            "metadata": metadata
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        // 네트워크 요청 (비동기)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // 응답 상태 코드 확인
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if !(200...299).contains(httpResponse.statusCode) {
            let errorString = String(data: data, encoding: .utf8) ?? "Unknown Error"
            print("Crossmint Minting Failed: \(errorString)")
            throw URLError(.badServerResponse)
        }
        
        // 성공 시 JSON 파싱 (서버가 돌려주는 NFT id 확인)
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let id = json["id"] as? String {
            // MVP 목적상, 해당 NFT를 볼 수 있는 Crossmint 콘솔 링크나 Solscan Devnet 지갑 주소 링크로 연결합니다.
            return "https://staging.crossmint.com/console/projects/\(projectId)/collections/default/nfts/\(id)"
        }
        
        // 기본 fallback URL
        return "https://staging.crossmint.com/console"
    }
}
