
import SwiftUI

import Photos
import PhotosUI
 
//MARK: 뷰 구조

// VStack {
//  영상 브피뷰
//  Next 버튼(영상 업로드시에만)
//  갤러리에 저장된 동영상들
// }


struct UPloadView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var authorizationStatus: PHAuthorizationStatus = .notDetermined
    @State private var selectedAsset: PHAsset? = nil
    @State private var recentVideos: [PHAsset] = []
    @State private var navigateToDetails = false
 
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
 
                VStack(spacing: 0) {

                    // MARK: 영상 프리뷰
                    ZStack(alignment: .topLeading) {
                        Rectangle()
                            .fill(Color(hex: "#1A1A2E"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 280)               
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "#7B2FBE"), lineWidth: 1))
                            .clipShape(RoundedRectangle(cornerRadius: 16)) 

                        if let asset = selectedAsset {
                            AssetThumbnailView(asset: asset, size: CGSize(width: UIScreen.main.bounds.width, height: 280))
                                .frame(height: 280)      
                                .clipShape(RoundedRectangle(cornerRadius: 16)) 
                                
                        } else {
                            VStack(spacing: 12) {
                                Image(systemName: "video.fill")
                                    .font(.system(size: 48))
                                    .foregroundColor(Color(hex: "#7B2FBE").opacity(0.6))
                                Text("Select a video below")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))                     

                    // MARK: Next버튼 - ZStack 밖, 프리뷰 바로 아래
                    if selectedAsset != nil {
                        Button(action: { navigateToDetails = true }) {
                            Text("Next")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color(hex: "#BF5AF2"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                        }
                        .background(Color(hex: "#1C1C1E"))
                    }
 
                    // MARK: Next버튼
                    
 
                    // MARK: 최근영상 스택
                    HStack {
                        HStack(spacing: 4) {
                            Text("Recent Videos")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 11))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        
                        //목업에서는 복사하기, 카메라 아이콘이 있는데 아직 구현안함
//                        Image(systemName: "square.on.square").foregroundColor(.white).font(.system(size: 16))
//                        Image(systemName: "camera").foregroundColor(.white).font(.system(size: 16))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(hex: "#111111"))
 
                    // MARK: 동영상 리스트들
                    switch authorizationStatus {
                    case .authorized, .limited:
                        ScrollView {
                            LazyVGrid(
                                columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: 4),
                                spacing: 2
                            ) {
                                ForEach(recentVideos, id: \.localIdentifier) { asset in
                                    VideoThumbnailCell(
                                        asset: asset,
                                        isSelected: selectedAsset?.localIdentifier == asset.localIdentifier,
                                        onTap: {
                                            withAnimation(.spring()) {
                                                selectedAsset = asset
                                            }
                                        }
                                    )
                                }
                            }
                            .padding(2)                       
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
 
                    case .denied, .restricted:
                        VStack(spacing: 16) {
                            Image(systemName: "video.slash.fill").font(.system(size: 40)).foregroundColor(.gray)
                            Text("Photo library access denied").foregroundColor(.gray)
                            Button("Open Settings") {
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url)
                                }
                            }
                            .foregroundColor(Color(hex: "#BF5AF2"))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
 
                    default:
                        ProgressView()
                            .tint(Color(hex: "#BF5AF2"))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToDetails) {
                UploadDetailsView(selectedAsset: selectedAsset)
            }
        }
        .onAppear { //클릭시 권한 요청로 구현함 추후 앱 첫 시작할때로 변경할 예정
            requestPermissionAndLoadVideos()
        }
    }
 
    // Helpers
    @ViewBuilder
    private func actionButton(icon: String) -> some View {
        Image(systemName: icon)
            .font(.system(size: 13))
            .foregroundColor(.white)
            .frame(width: 34, height: 34)
            .background(Color.black.opacity(0.7))
            .clipShape(Circle())
    }
 
    private func requestPermissionAndLoadVideos() {
        let current = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if current == .notDetermined {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    self.authorizationStatus = status
                    if status == .authorized || status == .limited {
                        self.fetchRecentVideos()
                    }
                }
            }
        } else {
            authorizationStatus = current
            if current == .authorized || current == .limited {
                fetchRecentVideos()
            }
        }
    }
 
    private func fetchRecentVideos() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.fetchLimit = 60
        let result = PHAsset.fetchAssets(with: .video, options: options)
        var assets: [PHAsset] = []
        result.enumerateObjects { asset, _, _ in assets.append(asset) }
        DispatchQueue.main.async { self.recentVideos = assets }
    }
}
 
// MARK: 동영상 썸네일
struct VideoThumbnailCell: View {
    let asset: PHAsset
    let isSelected: Bool
    let onTap: () -> Void
    @State private var thumbnail: UIImage? = nil
 
    private var cellSize: CGFloat { (UIScreen.main.bounds.width - 6) / 4 }
 
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Group {
                if let img = thumbnail {
                    Image(uiImage: img).resizable().scaledToFit()
                } else {
                    Color(hex: "#1C1C1E")
                }
            }
            .frame(width: cellSize, height: cellSize)
            .clipped()
 
            // 버퍼링
            let dur = Int(asset.duration)
            Text(String(format: "%d:%02d", dur / 60, dur % 60))
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 4).padding(.vertical, 2)
                .background(Color.black.opacity(0.6))
                .cornerRadius(3)
                .padding(4)
 
            if isSelected {
                // 선택 테두리
                Rectangle()
                    .stroke(Color(hex: "#BF5AF2"), lineWidth: 3)
                    .frame(width: cellSize, height: cellSize)
 
                // 번호 뱃지
                Circle()
                    .fill(Color(hex: "#BF5AF2"))
                    .frame(width: 22, height: 22)
                    .overlay(Text("1").font(.system(size: 11, weight: .bold)).foregroundColor(.white))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(4)
            }
        }
        .onTapGesture { onTap() }
        .onAppear { loadThumbnail() }
    }
 
    private func loadThumbnail() {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .opportunistic
        PHImageManager.default().requestImage(
            for: asset, targetSize: CGSize(width: 120, height: 120),
            contentMode: .aspectFill, options: options
        ) { image, _ in DispatchQueue.main.async { self.thumbnail = image } }
    }
}
 
// MARK: 선택된 영상의 썸네일을 크게 보여주는 뷰예요.
struct AssetThumbnailView: View {
    let asset: PHAsset
    let size: CGSize
    @State private var image: UIImage? = nil

    var body: some View {
        Group {
            if let img = image {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 280)      // ✅ 이 줄 추가
                    .clipped()              // ✅ 이 줄 추가
            } else {
                Color(hex: "#1A1A2E")
                    .overlay(ProgressView().tint(Color(hex: "#BF5AF2")))
            }
        }
        .onAppear { loadImage() }
        .onChange(of: asset) { _ in   // ✅ 추가
            image = nil               // 이전 이미지 초기화
            loadImage()               // 새 영상 로드
        }
    }

    private func loadImage() {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat
        PHImageManager.default().requestImage(
            for: asset, targetSize: size,
            contentMode: .aspectFit,
            options: options
        ) { img, _ in DispatchQueue.main.async { self.image = img } }
    }
}
 

 
#Preview {
    UPloadView()
}
