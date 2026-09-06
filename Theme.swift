import SwiftUI

enum IMDTheme {
    static let ground = Color(red: 0.969, green: 0.961, blue: 0.945)
    static let panel = Color(red: 0.929, green: 0.918, blue: 0.894)
    static let panelDeep = Color(red: 0.886, green: 0.871, blue: 0.835)
    static let ink = Color(red: 0.227, green: 0.216, blue: 0.200)
    static let inkSoft = Color(red: 0.420, green: 0.396, blue: 0.361)
    static let brass = Color(red: 0.690, green: 0.553, blue: 0.341)
    static let brassDeep = Color(red: 0.561, green: 0.435, blue: 0.243)
    static let verdigris = Color(red: 0.361, green: 0.420, blue: 0.353)
    static let rose = Color(red: 0.612, green: 0.357, blue: 0.306)
    static let line = Color(red: 0.851, green: 0.831, blue: 0.784)
    static let whatsapp = Color(red: 0.247, green: 0.478, blue: 0.361)
}

struct VeinDivider: View {
    var body: some View {
        Canvas { context, size in
            var path = Path()
            path.move(to: CGPoint(x: 0, y: size.height * 0.55))
            path.addCurve(to: CGPoint(x: size.width, y: size.height * 0.55), control1: CGPoint(x: size.width * 0.25, y: 0), control2: CGPoint(x: size.width * 0.7, y: size.height))
            context.stroke(path, with: .color(IMDTheme.brass.opacity(0.55)), lineWidth: 1)
        }
        .frame(height: 18)
    }
}
