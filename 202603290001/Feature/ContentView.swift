//
//  ContentView.swift
//  202603290001
//

import SwiftUI

struct ContentView: View {
    enum TabType {
        case library, upload, proof
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
                    Image(selectedTab == .proof ? "isSelectedProofButton" : "ProofButton")
                }
                .tag(TabType.proof)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
