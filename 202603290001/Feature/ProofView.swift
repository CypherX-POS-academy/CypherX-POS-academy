//
//  ProofView.swift
//  202603290001
//
//  Created by 백인하 on 3/31/26.
//


import SwiftUI

struct ProofView: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var isSubmitted: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // ─── 상단 네비게이션 바 ───
                HStack {
                    Button {
                        
                    } label: {
                        Image("isSelectedMenuButton")
                    }

                    Text("New Proof")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Button {
                        
                    } label: {
                        Image("PlusButton")
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                ScrollView {
                    VStack(spacing: 0) {
                        
                        // ─── 영상 업로드 박스 ───
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(white: 0.15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [8]))
                                        .foregroundColor(Color(white: 0.4))
                                )
                            
                            VStack(spacing: 12) {
                                Image(.bigViewButton)
                                
                                Text("Upload Video/Thumbnail")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                
                                Text("Tap to select your choreography file")
                                    .foregroundColor(Color(white: 0.5))
                                    .font(.subheadline)
                            }
                            .padding(.vertical, 36)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        
                        // ─── 제목 입력 ───
                        VStack(alignment: .leading, spacing: 8) {
                            Text("CHOREOGRAPHY TITLE")
                                .foregroundColor(Color(white: 0.5))
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                            
                            TextField("Enter title...", text: $title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color(white: 0.12))
                                .cornerRadius(10)
                                .padding(.horizontal, 20)
                        }
                        
                        // ─── 설명 입력 ───
                        VStack(alignment: .leading, spacing: 8) {
                            Text("DESCRIPTION")
                                .foregroundColor(Color(white: 0.5))
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 20)
                                .padding(.top, 30)
                            
                            // ⚠️ TextEditor는 placeholder가 없어서 직접 만들어야 해요
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $description)
                                    .foregroundColor(.white)
                                    .frame(minHeight: 100)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.clear)
                                
                                if description.isEmpty {
                                    Text("Describe the movement, energy, and inspiration...")
                                        .foregroundColor(Color(white: 0.35))
                                        .padding(.top, 8)
                                        .padding(.leading, 4)
                                        .allowsHitTesting(false)
                                }
                            }
                            .padding()
                            .background(Color(white: 0.12))
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                        }
                        
                        // ─── 블록체인 전송 버튼 ───
                        Button {
                            isSubmitted = true
                        } label: {
                            Text("SEND TO BLOCKCHAIN")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    LinearGradient(
                                        colors: [Color.purple, Color(red: 0.6, green: 0.3, blue: 1.0)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(14)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // ─── 성공 카드 (isSubmitted가 true일 때만 표시) ───
                        if isSubmitted {
                            VStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(Color.red.opacity(0.2))
                                        .frame(width: 52, height: 52)
                                    Image(systemName: "checkmark.shield.fill")
                                        .font(.system(size: 26))
                                        .foregroundColor(.red)
                                }
                                
                                Text("Proof successfully sent")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                
                                HStack(spacing: 4) {
                                    Text("View on Solana Explorer")
                                        .foregroundColor(.purple)
                                    Image(systemName: "arrow.up.right.square")
                                        .foregroundColor(.purple)
                                        .font(.footnote)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 50)
                            .background(Color(white: 0.12))
                            .cornerRadius(16)
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 20)
                    }
                }
            }
        }
        // ⚠️ 키보드가 올라왔을 때 뷰가 밀리지 않게
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    ProofView()
}
