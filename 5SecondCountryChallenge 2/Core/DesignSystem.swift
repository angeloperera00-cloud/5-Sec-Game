import SwiftUI

extension Color {
    static let warmIvory    = Color(hex: "#F7F3EA")
    static let softStone    = Color(hex: "#E9E4DA")
    static let deepNavy     = Color(hex: "#14213D")
    static let slateGray    = Color(hex: "#5C6670")
    static let mutedGold    = Color(hex: "#C9A227")
    static let deepOcean    = Color(hex: "#1F3B57")
    static let elegantGreen = Color(hex: "#2F7D5B")
    static let mutedRed     = Color(hex: "#B44B4B")
    static let cardWhite    = Color(hex: "#FFFFFF")
    static let darkCard     = Color(hex: "#0F1B2D")

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:  (a,r,g,b) = (255,(int>>8)*17,(int>>4 & 0xF)*17,(int & 0xF)*17)
        case 6:  (a,r,g,b) = (255,int>>16,int>>8 & 0xFF,int & 0xFF)
        case 8:  (a,r,g,b) = (int>>24,int>>16 & 0xFF,int>>8 & 0xFF,int & 0xFF)
        default: (a,r,g,b) = (255,0,0,0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255,
                  blue: Double(b)/255, opacity: Double(a)/255)
    }
}

enum DS {
    enum Spacing {
        static let xxs: CGFloat = 4
        static let xs:  CGFloat = 8
        static let sm:  CGFloat = 12
        static let md:  CGFloat = 16
        static let lg:  CGFloat = 24
        static let xl:  CGFloat = 32
        static let xxl: CGFloat = 48
    }
    enum Radius {
        static let sm:  CGFloat = 8
        static let md:  CGFloat = 14
        static let lg:  CGFloat = 20
        static let xl:  CGFloat = 28
        static let pill: CGFloat = 999
    }
    struct ShadowStyle {
        let color: Color; let radius: CGFloat; let x: CGFloat; let y: CGFloat
    }
    enum Shadow {
        static let soft = ShadowStyle(color: Color.deepNavy.opacity(0.06), radius: 12, x: 0, y: 4)
        static let card = ShadowStyle(color: Color.deepNavy.opacity(0.10), radius: 20, x: 0, y: 6)
        static let lift = ShadowStyle(color: Color.deepNavy.opacity(0.18), radius: 30, x: 0, y: 10)
    }
    enum Font {
        static func display(_ size: CGFloat, weight: SwiftUI.Font.Weight = .bold) -> SwiftUI.Font {
            .system(size: size, weight: weight, design: .rounded)
        }
        static func body(_ size: CGFloat, weight: SwiftUI.Font.Weight = .regular) -> SwiftUI.Font {
            .system(size: size, weight: weight, design: .default)
        }
        static let largeTitle = display(34)
        static let title      = display(28)
        static let title2     = display(22)
        static let title3     = display(18)
        static let headline   = body(16, weight: .semibold)
        static let body       = body(15)
        static let callout    = body(14)
        static let caption    = body(12)
    }
}

extension View {
    func appShadow(_ style: DS.ShadowStyle) -> some View {
        self.shadow(color: style.color, radius: style.radius, x: style.x, y: style.y)
    }
    func cardStyle(cornerRadius: CGFloat = DS.Radius.lg) -> some View {
        self.background(Color.cardWhite)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .appShadow(DS.Shadow.card)
    }
    func darkCardStyle(cornerRadius: CGFloat = DS.Radius.lg) -> some View {
        self.background(Color.darkCard)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .appShadow(DS.Shadow.lift)
    }
}
