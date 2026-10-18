import SwiftUI

struct AppleAccountSection: View {
    var body: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(LinearGradient(colors: [Color(white: 0.72), Color(white: 0.20)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 60, height: 60)
            VStack(alignment: .leading, spacing: 4) {
                Text("88")
                    .font(.title3.weight(.semibold))
                Text("Apple Account, iCloud\nand more")
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    NavigationStack {
        List { AppleAccountSection() }
    }
}
