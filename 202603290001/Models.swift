import Foundation

// 해커톤용 간이 모델
struct Choreography: Codable, Identifiable {
    let id: String // 서버에서 주는 txId (블록체인 트랜잭션 아이디)
    let title: String
    let description: String?
    let videoUrl: String
    let hash: String
    let explorerUrl: String
    let createdAt: String
}
