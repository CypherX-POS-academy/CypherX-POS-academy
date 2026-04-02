//
//  TabBarView.swift
//  202603290001
//

import SwiftUI

import Combine

class TabRouter: ObservableObject {
    @Published var selectedTab: TabType = .library
}
 
enum TabType {
    case library, upload, myPage
}
 
struct TabBarView: View {
    @StateObject private var tabRouter = TabRouter()
 
    var body: some View {
        TabView(selection: $tabRouter.selectedTab) {
            ListView()
                .tabItem {
                    Image(tabRouter.selectedTab == .library ? "isSelectedLibraryButton" : "LibraryButton")
                }
                .tag(TabType.library)
 
            UPloadView()
                .tabItem {
                    Image(tabRouter.selectedTab == .upload ? "isSelectedUploadButton" : "UploadButton")
                }
                .tag(TabType.upload)
 
            MyPageView()
                .tabItem {
                    Image(tabRouter.selectedTab == .myPage ? "isSelectedMyPageButton" : "MyPageButton")
                }
                .tag(TabType.myPage)
        }
        .preferredColorScheme(.dark)
        .environmentObject(tabRouter) // ✅ 하위 뷰 전체에 주입
    }
}
 
#Preview {
    TabBarView()
}
