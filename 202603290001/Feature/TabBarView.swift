//
//  TabBarView.swift
//  202603290001
//

import SwiftUI

struct TabBarView: View {
    enum TabType {
        case library, upload, myPage, proof
    }
        
    @State private var selectedTab: TabType = .library
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ListView()
                .tabItem {
                    Image(selectedTab == .library ? "isSelectedLibraryButton" : "LibraryButton")
                }
                .tag(TabType.library)
                        
                        
            UploadView()
                .tabItem {
                    Image(selectedTab == .upload ? "isSelectedUploadButton" : "UploadButton")
                }
                .tag(TabType.upload)
            
            UploadView()
                .tabItem {
                    Image(selectedTab == .myPage ? "isSelectedMyPageButton" : "MyPageButton")
                }
                .tag(TabType.myPage)
                        

            UploadView()
                .tabItem {
                    Image(selectedTab == .proof ? "isSelectedProofButton" : "ProofButton")
                }
                .tag(TabType.proof)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    TabBarView()
}
