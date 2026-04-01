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
                        
                        
            UPloadView()
                .tabItem {
                    Image(selectedTab == .upload ? "isSelectedUploadButton" : "UploadButton")
                }
                .tag(TabType.upload)
            
            
            MyPageView()
                .tabItem {
                    Image(selectedTab == .myPage ? "isSelectedMyPageButton" : "MyPageButton")
                }
                .tag(TabType.myPage)
            
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    TabBarView()
}
