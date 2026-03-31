import SwiftUI

extension Color {
    // 1. Background & Base
    static let surface = Color("surface")
    static let surfaceContainerLowest = Color("surface_container_lowest")
    static let surfaceContainerLow = Color("surface_container_low")
    static let surfaceContainer = Color("surface_container")
    static let surfaceContainerHighest = Color("surface_container_highest")
        
    // 2. Vibrant Accents
    static let primaryBrand = Color("primary") // primary is a reserved keyword in some contexts, using primaryBrand
    static let primaryDim = Color("primary_dim")
    static let secondaryBrand = Color("secondary")
    static let tertiaryBrand = Color("tertiary")
    
    // 3. Functional & Contrast
    static let errorBrand = Color("error")
    static let outlineVariant = Color("outline_variant")
    static let onSurfaceVariant = Color("on_surface_variant")
}

// Typography & Style Utilities
struct DigitalStageStyle {
    static func primaryGradient() -> LinearGradient {
        LinearGradient(
            colors: [.primaryBrand, .primaryDim],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // Glassmorphism Modifier
    struct GlassModifier: ViewModifier {
        func body(content: Content) -> some View {
            content
                .background(.ultraThinMaterial)
                .background(Color.surfaceContainerHighest.opacity(0.7))
                .cornerRadius(24) // xl corner radius
        }
    }
}

extension View {
    func glassStyle() -> some View {
        self.modifier(DigitalStageStyle.GlassModifier())
    }
}

// Typography Specs from DESIGN.md
extension Font {
    static let displayLg = Font.system(size: 56, weight: .black, design: .rounded) // 3.5rem
    static let headlineLg = Font.system(size: 32, weight: .bold, design: .rounded) // 2rem
    static let titleMd = Font.system(size: 18, weight: .semibold, design: .default) // 1.125rem
    static let bodyMd = Font.system(size: 14, weight: .regular, design: .default) // 0.875rem
    static let labelMd = Font.system(size: 12, weight: .bold, design: .default) // interaction label
}

