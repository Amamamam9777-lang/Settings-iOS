//
//  BatteryView.swift
//  Preferences
//
//  Demo Battery Usage screen styled after the supplied references.
//  Values and app usage are fictional demonstration data.
//

import SwiftUI

struct BatteryView: View {
    @State private var selectedPeriod = 0
    @State private var showAllApps = false

    private let ink = Color.black
    private let card = Color(red: 0.115, green: 0.115, blue: 0.125)
    private let muted = Color(red: 0.56, green: 0.56, blue: 0.59)
    private let blue = Color(red: 0.02, green: 0.57, blue: 1.0)
    private let green = Color(red: 0.20, green: 0.82, blue: 0.39)
    private let yellow = Color(red: 1.0, green: 0.82, blue: 0.02)

    private struct AppUsage: Identifiable {
        let id: String
        let name: String
        let assetName: String
        let percent: Int
        let screen: String
        let background: String?
    }

    private let apps: [AppUsage] = [
        .init(id: "pubg", name: "PUBG MOBILE", assetName: "BatteryAppPUBG", percent: 32, screen: "46m", background: nil),
        .init(id: "safari", name: "Safari", assetName: "BatteryAppSafari", percent: 31, screen: "52m", background: nil),
        .init(id: "swiftgram", name: "Swiftgram", assetName: "BatteryAppSwiftgram", percent: 30, screen: "1h 19m", background: "10m"),
        .init(id: "tiktok", name: "TikTok", assetName: "BatteryAppTikTok", percent: 22, screen: "1h 10m", background: "4m"),
        .init(id: "happ", name: "Happ", assetName: "BatteryAppHapp", percent: 14, screen: "1m", background: "4h 40m"),
        .init(id: "whatsapp", name: "WhatsApp", assetName: "BatteryAppWhatsApp", percent: 6, screen: "15m", background: "9m"),
        .init(id: "files", name: "Files", assetName: "BatteryAppFiles", percent: 5, screen: "8m", background: "1m")
    ]

    private var visibleApps: [AppUsage] {
        showAllApps ? apps : Array(apps.prefix(4))
    }

    private let weekUsage: [CGFloat] = [0.68, 0.83, 0.48, 0.75, 0.45, 0.64, 0.43, 0.0]
    private let hourlyBattery: [CGFloat] = [
        0.08, 0.14, 0.35, 0.45, 0.47, 0.47, 0.46, 0.46,
        0.45, 0.45, 0.46, 0.54, 0.42, 0.18, 0.26, 0.50,
        0.47, 0.49, 0.59, 0.75, 0.82, 0.64, 0.45
    ]
    private let chargeHours: Set<Int> = [0, 1, 2, 3, 7, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                Text("Daily Usage")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(muted)
                    .padding(.horizontal, 20)
                    .padding(.top, 4)

                dailyUsageCard

                appUsageCard

                otherUsageCard

                Text("Demonstration statistics only. These values do not represent actual device battery activity.")
                    .font(.footnote)
                    .foregroundStyle(muted)
                    .padding(.horizontal, 22)
                    .padding(.bottom, 22)
            }
            .padding(.top, 8)
        }
        .background(ink.ignoresSafeArea())
        .navigationTitle("Battery Usage")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }

    private var dailyUsageCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(selectedPeriod == 0
                 ? "You used less battery on Sunday than you usually do."
                 : "Your battery usage over the last 10 days.")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)

            Rectangle().fill(Color.white.opacity(0.12)).frame(height: 1)

            VStack(alignment: .trailing, spacing: 2) {
                Text(selectedPeriod == 0 ? "109%" : "96%")
                    .font(.system(size: 38, weight: .regular))
                    .foregroundStyle(blue)
                Text(selectedPeriod == 0 ? "18 Oct 2026" : "Last 10 Days")
                    .font(.system(size: 17))
                    .foregroundStyle(muted)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 80)

            weeklyChart

            HStack(spacing: 16) {
                legendDot(color: Color.white.opacity(0.25), title: "All Day")
                legendDot(color: Color.white.opacity(0.38), title: "Usage by End of Day")
            }
            .font(.system(size: 13))
            .foregroundStyle(muted)

            batteryTimeline

            Rectangle().fill(Color.white.opacity(0.12)).frame(height: 1)
                .padding(.top, 4)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Screen On").font(.system(size: 16, weight: .medium)).foregroundStyle(muted)
                    Text(selectedPeriod == 0 ? "5h 7m" : "31h 42m")
                        .font(.system(size: 25, weight: .regular)).foregroundStyle(.white)
                }
                Spacer()
                VStack(alignment: .leading, spacing: 6) {
                    Text("Screen Off").font(.system(size: 16, weight: .medium)).foregroundStyle(muted)
                    Text(selectedPeriod == 0 ? "38m" : "8h 35m")
                        .font(.system(size: 25, weight: .regular)).foregroundStyle(.white)
                }
                .frame(width: 145, alignment: .leading)
            }
            .padding(.top, 2)
        }
        .padding(20)
        .background(card, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .padding(.horizontal, 20)
    }

    private var weeklyChart: some View {
        VStack(spacing: 6) {
            GeometryReader { proxy in
                let height = proxy.size.height
                ZStack(alignment: .bottom) {
                    VStack(spacing: 0) {
                        chartGuide(label: "200%")
                        Spacer()
                        chartGuide(label: "100%")
                        Spacer()
                        chartGuide(label: "0%")
                    }
                    HStack(alignment: .bottom, spacing: 7) {
                        ForEach(Array(weekUsage.enumerated()), id: \.offset) { index, value in
                            VStack(spacing: 6) {
                                Spacer(minLength: 0)
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(
                                        index == 6
                                        ? AnyShapeStyle(blue)
                                        : AnyShapeStyle(LinearGradient(
                                            colors: [Color(white: 0.48), Color(white: 0.30)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        ))
                                    )
                                    .frame(height: max(2, height * value))
                                Text(["M", "T", "W", "T", "F", "S", "S", "M"][index])
                                    .font(.system(size: 13))
                                    .foregroundStyle(index == 6 ? blue : muted)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.trailing, 48)
                    Rectangle().fill(blue.opacity(0.9))
                        .frame(width: 1.2)
                        .frame(height: height * 0.92)
                        .overlay(alignment: .top) {
                            Circle().fill(blue).frame(width: 5, height: 5).offset(y: -2)
                        }
                        .offset(x: proxy.size.width * 0.38, y: -18)
                }
            }
            .frame(height: 190)

            HStack {
                Text("12/10")
                Spacer()
            }
            .font(.system(size: 13))
            .foregroundStyle(muted)
        }
    }

    private func chartGuide(label: String) -> some View {
        HStack(spacing: 6) {
            Rectangle().fill(Color.white.opacity(0.18)).frame(height: 1)
            Text(label)
                .font(.system(size: 13))
                .foregroundStyle(muted)
                .frame(width: 45, alignment: .leading)
        }
    }

    private func legendDot(color: Color, title: String) -> some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 9, height: 9)
            Text(title)
        }
    }

    private var batteryTimeline: some View {
        VStack(spacing: 8) {
            GeometryReader { proxy in
                let width = proxy.size.width
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(0..<3, id: \.self) { _ in
                            Rectangle().fill(green).frame(height: 5)
                        }
                    }
                    .clipShape(Capsule())
                    .padding(.bottom, 0)

                    HStack(alignment: .bottom, spacing: 2) {
                        ForEach(Array(hourlyBattery.enumerated()), id: \.offset) { index, value in
                            RoundedRectangle(cornerRadius: 2, style: .continuous)
                                .fill(barColor(index: index))
                                .frame(maxWidth: .infinity)
                                .frame(height: max(8, 138 * value))
                        }
                    }
                    .frame(height: 138, alignment: .bottom)
                    .overlay(alignment: .top) {
                        VStack(spacing: 0) {
                            ForEach([1.0, 0.5, 0.0], id: \.self) { _ in
                                Rectangle().fill(Color.white.opacity(0.15)).frame(height: 1)
                                Spacer(minLength: 0)
                            }
                        }
                        .allowsHitTesting(false)
                    }
                    .overlay(alignment: .top) {
                        HStack {
                            ForEach([2, 7, 15], id: \.self) { _ in
                                Image(systemName: "bolt.fill")
                                    .font(.system(size: 18, weight: .black))
                                    .foregroundStyle(.black)
                                    .padding(2)
                                    .background(green, in: Circle())
                                Spacer()
                            }
                        }
                        .offset(y: -11)
                    }
                }
                .frame(width: width, height: 145, alignment: .top)
            }
            .frame(height: 145)

            HStack {
                Text("00")
                Spacer()
                Text("06")
                Spacer()
                Text("12")
                Spacer()
                Text("18")
                Spacer()
            }
            .font(.system(size: 13))
            .foregroundStyle(muted)
        }
        .padding(.top, 2)
    }

    private func barColor(index: Int) -> Color {
        if [4, 5, 6, 9, 21, 22].contains(index) { return yellow }
        return green
    }

    private var appUsageCard: some View {
        VStack(spacing: 0) {
            ForEach(visibleApps) { app in
                appRow(app)
                if app.id != visibleApps.last?.id {
                    Rectangle().fill(Color.white.opacity(0.13))
                        .frame(height: 1)
                        .padding(.leading, 82)
                }
            }

            Button {
                withAnimation(.easeInOut(duration: 0.2)) { showAllApps.toggle() }
            } label: {
                HStack {
                    Text(showAllApps ? "Show Less" : "Show More")
                        .font(.system(size: 17))
                        .foregroundStyle(blue)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
            }
            .buttonStyle(.plain)
        }
        .background(card, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .padding(.horizontal, 20)
    }

    private func appRow(_ app: AppUsage) -> some View {
        HStack(spacing: 14) {
            appIcon(app)
                .frame(width: 48, height: 48)

            VStack(alignment: .leading, spacing: 3) {
                Text(app.name)
                    .font(.system(size: 17))
                    .foregroundStyle(.white)
                Text("On screen: \(app.screen)")
                    .font(.system(size: 14))
                    .foregroundStyle(muted)
                if let background = app.background {
                    Text("Background: \(background)")
                        .font(.system(size: 14))
                        .foregroundStyle(muted)
                }
            }

            Spacer(minLength: 4)

            Text("\(app.percent)%")
                .font(.system(size: 17))
                .foregroundStyle(muted)

            Image(systemName: "chevron.right")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.white.opacity(0.35))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
    }

    private func appIcon(_ app: AppUsage) -> some View {
        Image(app.assetName)
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 11, style: .continuous)
                    .stroke(Color.white.opacity(0.18), lineWidth: 0.7)
            )
    }

    private var otherUsageCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Other Battery Usage")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(muted)
                .padding(.horizontal, 20)
                .padding(.vertical, 18)

            Rectangle().fill(Color.white.opacity(0.13)).frame(height: 1).padding(.horizontal, 20)

            HStack(spacing: 14) {
                Image(systemName: "iphone")
                    .font(.system(size: 26))
                    .foregroundStyle(blue)
                    .frame(width: 48, height: 48)
                    .background(Color.black, in: RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 3) {
                    Text("Home & Lock Screen").font(.system(size: 17)).foregroundStyle(.white)
                    Text("On screen: 31m").font(.system(size: 14)).foregroundStyle(muted)
                }
                Spacer()
                Text("1%").font(.system(size: 17)).foregroundStyle(muted)
                Image(systemName: "chevron.right").foregroundStyle(Color.white.opacity(0.35))
            }
            .padding(20)
        }
        .background(card, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .padding(.horizontal, 20)
    }
}

#Preview {
    NavigationStack {
        BatteryView()
    }
    .preferredColorScheme(.dark)
}
