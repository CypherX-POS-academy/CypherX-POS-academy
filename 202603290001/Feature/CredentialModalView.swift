//
//  CredentialModalView.swift
//  202603290001
//
//  Created by 백인하 on 4/1/26.
//

import SwiftUI

struct CredentialModalView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            
            // ─── 1. 배경 블러 + 딤 레이어 ───
            // ⚠️ 이게 글래스모피즘의 핵심. 뒤 화면을 직접 blur 처리
            Rectangle()
                .fill(.black.opacity(0.55))
                .background(.ultraThinMaterial)  // 시스템 블러
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                        isPresented = false
                    }
                }
            
            // ─── 2. 글래스 카드 ───
            glassCard
                .padding(.horizontal, 28)
                .padding(.vertical, 140)
                // 카드 탭은 닫기 막기
                .onTapGesture {}
        }
    }
    
    // ─── 카드 본체 (별도로 분리해서 가독성 UP) ───
    var glassCard: some View {
        ZStack(alignment: .topTrailing) {
            
            // ── 유리 재질 레이어 쌓기 ──
            ZStack {
                // 레이어 1: 어두운 베이스
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.white.opacity(0.05))
                
                // 레이어 2: 상단 하이라이트 (유리의 빛 반사 느낌)
                RoundedRectangle(cornerRadius: 28)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.15),
                                Color.white.opacity(0.03)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // 레이어 3: 테두리 (유리 엣지)
                RoundedRectangle(cornerRadius: 28)
                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
                
                // 레이어 4: 내부 상단 얇은 하이라이트선
                RoundedRectangle(cornerRadius: 28)
                    .stroke(
                        LinearGradient(
                            colors: [Color.white.opacity(0.4), Color.clear],
                            startPoint: .top,
                            endPoint: .center
                        ),
                        lineWidth: 0.5
                    )
            }
            .shadow(color: .black.opacity(0.5), radius: 40, x: 0, y: 20)
            .shadow(color: .purple.opacity(0.15), radius: 20, x: 0, y: 0)
            
            // ── 카드 콘텐츠 ──
            VStack(spacing: 0) {
                
                // PROFESSIONAL CREDENTIAL
                VStack(spacing: 10) {
                    Text("PROFESSIONAL CREDENTIAL")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.primary500)
                        .kerning(2.5)
                    
                    Rectangle()
                        .fill(.primary500)
                        .frame(width: 36, height: 1)
                }
                .padding(.top, 36)
                
                // 구분선
                glassHRule
                    .padding(.top, 20)
                
                // COPYRIGHT HOLDER
                VStack(spacing: 10) {
                    Text("COPYRIGHT HOLDER")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(Color.white.opacity(0.5))
                        .kerning(2)
                    
                    Text("ELENA VOSS")
                        .font(.system(size: 30, weight: .black))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.3), radius: 8)
                }
                .padding(.vertical, 28)
                
                // 구분선
                glassHRule
                
                // PROVENANCE / VALIDATOR
                HStack(spacing: 0) {
                    // 왼쪽
                    VStack(spacing: 8) {
                        Text("PROVENANCE")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(Color.white.opacity(0.5))
                            .kerning(1.5)
                        
                        Text("PERMANENT")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.6))
                    }
                    .frame(maxWidth: .infinity)
                    
                    // 세로 구분선
                    Rectangle()
                        .fill(Color.white.opacity(0.12))
                        .frame(width: 1, height: 52)
                    
                    // 오른쪽
                    VStack(spacing: 8) {
                        Text("VALIDATOR")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(Color.white.opacity(0.5))
                            .kerning(1.5)
                        
                        Text("SOLANA MAINNET")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 24)
                
                // 구분선
                glassHRule
                
                // 하단 인용문
                Text("\"This record serves as the immutable digital footprint of the original choreography, protected by cryptographic proof and verified artist intent.\"")
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 28)
            }
            
            // ── 우상단 방패 아이콘 ──
            Image(systemName: "checkmark.shield.fill")
                .font(.system(size: 72))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.12),
                            Color.white.opacity(0.04)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .white.opacity(0.1), radius: 4)
                .padding(.trailing, 16)
                .padding(.top, 12)
        }
    }
    
    // ── 재사용 가능한 구분선 ──
    var glassHRule: some View {
        Rectangle()
            .fill(Color.white.opacity(0.1))
            .frame(height: 0.5)
            .padding(.horizontal, 24)
    }
}

// ─── 프리뷰 ───
#Preview {
    CredentialModalView(isPresented: .constant(true))
}
