import Foundation

struct Choreography: Codable, Identifiable {
    let id: String
    let name: String
    let profileImage: String
    let title: String
    let description: String?
    let genre: String?
    let videoUrl: String
    let hash: String
    let explorerUrl: String
    let createdAt: String
    let solanaWalletAddress: String
}
