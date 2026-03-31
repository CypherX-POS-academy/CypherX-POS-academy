//
//  ContentView.swift
//  202603290001
//

import SwiftUI

struct ContentView: View {
    
    /*
    init() {
        // 프리미엄 탭바 스타일 적용
        UITabBar.appearance().backgroundColor = UIColor.black
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }
     */
    
    var body: some View {
        TabView {
            UploadView()
                .tabItem {
                    Label("Mint", systemImage: "plus.square.fill.on.square.fill")
                }
            
            ListView()
                .tabItem {
                    Label("Explore", systemImage: "square.grid.2x2.fill")
                }
        }
        .preferredColorScheme(.dark)
        .tint(.primary500)
        .toolbarBackground(.black, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)

    }
}

#Preview {
    ContentView()
}
