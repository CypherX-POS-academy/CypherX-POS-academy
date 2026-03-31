import Foundation
import Combine

class NetworkManager: ObservableObject {
    @Published var choreographies: [Choreography] = []
    
    // 시뮬레이터에서 로컬 호스트 접근시 보통 http://127.0.0.1:3000 사용 (실기기에서는 IP 주소 변경 필요)
    private let serverURL = "http://127.0.0.1:3000/api/choreography"
    
    // 안무 목록 조회
    func fetchChoreographies() {
        guard let url = URL(string: "\(serverURL)/list") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Fetch error: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode([Choreography].self, from: data)
                    DispatchQueue.main.async {
                        // 최신순이 위로 오도록 리스트 뒤집어서 저장
                        self.choreographies = decoded.reversed()
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    // ----------------------------------------------------
    // [V2 기능] multipart/form-data를 통한 비디오 파일 서버 업로드 & 해싱 완료본 받아오기
    func uploadVideo(title: String, description: String, fileURL: URL, creatorAddress: String, completion: @escaping (String?, String?, Error?) -> Void) {
        guard let url = URL(string: "\(serverURL)/upload") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        // Text Fields
        let parameters = [
            "title": title,
            "description": description,
            "creatorAddress": creatorAddress
        ]
        
        for (key, value) in parameters {
            body.append(boundaryPrefix.data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // File Field
        body.append(boundaryPrefix.data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"videoFile\"; filename=\"video.mov\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: video/quicktime\r\n\r\n".data(using: .utf8)!)
        
        guard let videoData = try? Data(contentsOf: fileURL) else {
            completion(nil, nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Failed to read video file"]))
            return
        }
        
        body.append(videoData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, nil, error)
                return
            }
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let txId = json["txId"] as? String,
                       let explorerUrl = json["explorerUrl"] as? String {
                        completion(txId, explorerUrl, nil)
                    } else {
                        completion(nil, nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON response"]))
                    }
                } catch {
                    completion(nil, nil, error)
                }
            }
        }.resume()
    }
}
