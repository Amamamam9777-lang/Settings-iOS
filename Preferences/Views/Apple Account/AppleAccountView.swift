// Local demonstration Apple Account / iCloud screens.
// This is a visual mockup only; it does not sign in to or modify a real Apple Account.
import SwiftUI

struct AppleAccountView: View {
    private let accountSections: [[DemoAccountItem]] = [
        [
            .init(title: "Personal Information", symbol: "person.text.rectangle.fill", tint: .gray, destination: .detail("Personal Information", "person.text.rectangle.fill")),
            .init(title: "Sign-In & Security", symbol: "checkmark.shield.fill", tint: .white, destination: .detail("Sign-In & Security", "checkmark.shield.fill")),
            .init(title: "Payment & Shipping", symbol: "creditcard.fill", tint: .white, destination: .detail("Payment & Shipping", "creditcard.fill")),
            .init(title: "Subscriptions", symbol: "arrow.clockwise.circle", tint: .white, destination: .detail("Subscriptions", "arrow.clockwise.circle"))
        ],
        [
            .init(title: "iCloud", symbol: "cloud.fill", tint: Color(red: 0.25, green: 0.68, blue: 1), status: "5 GB", destination: .icloud),
            .init(title: "Family", symbol: "person.3.fill", tint: .cyan, status: "Set Up", destination: .detail("Family", "person.3.fill")),
            .init(title: "Find My", symbol: "dot.radiowaves.left.and.right", tint: .green, destination: .detail("Find My", "dot.radiowaves.left.and.right")),
            .init(title: "Media & Purchases", symbol: "appstore.fill", tint: .blue, destination: .detail("Media & Purchases", "appstore.fill")),
            .init(title: "Sign in with Apple", symbol: "apple.logo", tint: .white, destination: .detail("Sign in with Apple", "apple.logo"))
        ]
    ]

    var body: some View {
        CustomList(title: "Apple Account") {
            VStack(spacing: 8) {
                DemoAvatar(size: 126)
                Text("88")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(.primary)
                Text("amamamam9777@icloud.com")
                    .font(.system(size: 17))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 22)
            .padding(.bottom, 28)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)

            ForEach(Array(accountSections.enumerated()), id: \.offset) { _, section in
                Section {
                    ForEach(section) { item in
                        DemoAccountRow(item: item)
                    }
                }
            }

            Section {
                NavigationLink {
                    DemoDeviceInfoView()
                } label: {
                    HStack(spacing: 14) {
                        DemoPhoneGlyph()
                            .frame(width: 42, height: 54)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("iPhone (S)")
                                .font(.body)
                                .foregroundStyle(.primary)
                            Text("This iPhone 13 Pro")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }

            Section {
                DemoAccountRow(item: .init(title: "Contact Key Verification", symbol: "person.crop.circle.badge.checkmark", tint: .white, status: "Off", destination: .detail("Contact Key Verification", "person.crop.circle.badge.checkmark")))
            }

            Section {
                NavigationLink {
                    DemoAccountDetailView(title: "Sign Out", symbol: "rectangle.portrait.and.arrow.right")
                } label: {
                    Text("Sign Out")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundStyle(.red)
                        .padding(.vertical, 8)
                }
            }
        }
    }
}

private struct DemoAccountItem: Identifiable {
    enum Destination { case icloud, detail(String, String) }
    let id = UUID()
    let title: String
    let symbol: String
    let tint: Color
    var status: String = ""
    let destination: Destination
}

private struct DemoAccountRow: View {
    let item: DemoAccountItem
    var body: some View {
        Group {
            switch item.destination {
            case .icloud:
                NavigationLink { DemoICloudView() } label: { rowContent }
            case let .detail(title, symbol):
                NavigationLink { DemoAccountDetailView(title: title, symbol: symbol) } label: { rowContent }
            }
        }
    }

    private var rowContent: some View {
        HStack(spacing: 14) {
            DemoServiceIcon(symbol: item.symbol, tint: item.tint)
            Text(item.title)
                .foregroundStyle(.primary)
            Spacer(minLength: 8)
            if !item.status.isEmpty {
                Text(item.status)
                    .foregroundStyle(.secondary)
            }
        }
        .contentShape(Rectangle())
        .padding(.vertical, 5)
    }
}

private struct DemoAvatar: View {
    var size: CGFloat
    var body: some View {
        Circle()
            .fill(LinearGradient(colors: [Color(white: 0.72), Color(white: 0.20)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: size, height: size)
            .overlay(Circle().stroke(Color.white.opacity(0.06), lineWidth: 1))
            .accessibilityLabel("Demo account profile picture")
    }
}

private struct DemoServiceIcon: View {
    let symbol: String
    let tint: Color
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(LinearGradient(colors: [Color(white: 0.30), Color(white: 0.12)], startPoint: .topLeading, endPoint: .bottomTrailing))
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color.white.opacity(0.20), lineWidth: 0.8)
            Image(systemName: symbol)
                .font(.system(size: 21, weight: .semibold))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(tint)
        }
        .frame(width: 36, height: 36)
    }
}

private struct DemoPhoneGlyph: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7)
                .fill(Color.black)
                .frame(width: 27, height: 48)
                .overlay(RoundedRectangle(cornerRadius: 7).stroke(Color.gray.opacity(0.8), lineWidth: 1.4))
            RoundedRectangle(cornerRadius: 5)
                .fill(LinearGradient(colors: [Color.cyan.opacity(0.8), Color.blue, Color(red: 0.1, green: 0.2, blue: 0.55)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 22, height: 42)
            Ellipse().fill(Color.white.opacity(0.35)).frame(width: 11, height: 31).rotationEffect(.degrees(-25)).offset(x: -3, y: -3)
            Capsule().fill(Color.black).frame(width: 9, height: 2).offset(y: -19)
        }
    }
}

struct DemoICloudView: View {
    @State private var photos = true
    @State private var drive = true
    @State private var passwords = true
    @State private var notes = true
    @State private var messages = false
    @State private var mail = false

    var body: some View {
        CustomList(title: "iCloud") {
            Section {
                HStack(spacing: 14) {
                    DemoServiceIcon(symbol: "cloud.fill", tint: .cyan).frame(width: 42, height: 42)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("iCloud Storage").font(.headline)
                        Text("1.2 GB of 5 GB Used").font(.subheadline).foregroundStyle(.secondary)
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color.gray.opacity(0.25))
                                Capsule().fill(Color.blue).frame(width: geometry.size.width * 0.24)
                            }
                        }.frame(height: 6)
                    }
                }.padding(.vertical, 8)
                NavigationLink { DemoAccountDetailView(title: "Manage Account Storage", symbol: "externaldrive.fill") } label: { Label("Manage Account Storage", systemImage: "externaldrive.fill") }
                NavigationLink { DemoAccountDetailView(title: "Change Storage Plan", symbol: "plus.circle.fill") } label: { Label("Change Storage Plan", systemImage: "plus.circle.fill") }
            }
            Section("Saved to iCloud") {
                Toggle(isOn: $photos) { Label("Photos", systemImage: "photo.fill") }
                Toggle(isOn: $drive) { Label("iCloud Drive", systemImage: "folder.fill") }
                Toggle(isOn: $passwords) { Label("Passwords and Keychain", systemImage: "key.horizontal.fill") }
                Toggle(isOn: $notes) { Label("Notes", systemImage: "note.text") }
                Toggle(isOn: $messages) { Label("Messages in iCloud", systemImage: "message.fill") }
                Toggle(isOn: $mail) { Label("iCloud Mail", systemImage: "envelope.fill") }
            }
        }
    }
}

struct DemoDeviceInfoView: View {
    var body: some View {
        CustomList(title: "Device Info") {
            VStack(spacing: 8) {
                DemoPhoneGlyph().frame(width: 64, height: 94)
                Text("iPhone (S)").font(.system(size: 25, weight: .medium))
                Text("This iPhone 13 Pro").font(.system(size: 17)).foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)

            Section {
                DemoAccountRow(item: .init(title: "Find My iPhone", symbol: "dot.radiowaves.left.and.right", tint: .green, status: "Off", destination: .detail("Find My iPhone", "dot.radiowaves.left.and.right")))
                DemoAccountRow(item: .init(title: "iCloud Backup", symbol: "arrow.clockwise.icloud.fill", tint: .cyan, status: "Off", destination: .detail("iCloud Backup", "arrow.clockwise.icloud.fill")))
                DemoAccountRow(item: .init(title: "AppleCare & Warranty", symbol: "apple.logo", tint: .red, destination: .detail("AppleCare & Warranty", "apple.logo")))
            }
            Section(header: Text("Device Info")) {
                LabeledContent("Model", value: "iPhone 13 Pro")
                LabeledContent("Version", value: "iOS 26.5")
                LabeledContent("Serial Number", value: "DEMO-SERIAL-0000")
                LabeledContent("IMEI", value: "Not provided")
            } footer: {
                Text("Demo device information. These values are not read from the actual device.")
            }
            Section {
                Text("This is a demo interface. No real Apple Account is signed in.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct DemoAccountDetailView: View {
    let title: String
    let symbol: String
    var body: some View {
        CustomList(title: title) {
            Section {
                Label(title, systemImage: symbol)
                Text("Demo screen. This feature is not connected to Apple services.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack { AppleAccountView() }
}
