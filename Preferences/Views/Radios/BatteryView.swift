// BatteryView.swift
// Demonstration-only iOS-style Battery settings and usage screens.
// All battery statistics below are fictional UI demo data, not device telemetry.

import SwiftUI

private enum BatteryPalette {
    static let background = Color.black
    static let card = Color(red: 0.115, green: 0.115, blue: 0.125)
    static let muted = Color(red: 0.56, green: 0.56, blue: 0.59)
    static let blue = Color(red: 0.02, green: 0.57, blue: 1.0)
    static let green = Color(red: 0.20, green: 0.82, blue: 0.39)
    static let yellow = Color(red: 1.0, green: 0.82, blue: 0.02)
    static let separator = Color.white.opacity(0.13)
}

private struct BatteryDemoApp: Identifiable {
    let id: String
    let name: String
    let asset: String
    let percent: Int
    let screen: String
    let background: String?

    static let all: [BatteryDemoApp] = [
        .init(id: "tiktok", name: "TikTok", asset: "BatteryAppTikTok", percent: 18, screen: "50m", background: "5m"),
        .init(id: "swiftgram", name: "Swiftgram", asset: "BatteryAppSwiftgram", percent: 8, screen: "27m", background: "3m"),
        .init(id: "safari", name: "Safari", asset: "BatteryAppSafari", percent: 7, screen: "17m", background: nil),
        .init(id: "pubg", name: "PUBG MOBILE", asset: "BatteryAppPUBG", percent: 32, screen: "46m", background: nil),
        .init(id: "happ", name: "Happ", asset: "BatteryAppHapp", percent: 14, screen: "1m", background: "4h 40m"),
        .init(id: "whatsapp", name: "WhatsApp", asset: "BatteryAppWhatsApp", percent: 6, screen: "15m", background: "9m"),
        .init(id: "Files", name: "Files", asset: "BatteryAppFiles", percent: 5, screen: "8m", background: "1m")
    ]
}

struct BatteryView: View {
    @State private var batteryPercentage = true
    @State private var lowPowerMode = false
    @State private var optimizedCharging = true
    @State private var actualBatteryLevel: Int = 0
    @State private var batteryIsCharging = false

    private func refreshBatteryStatus() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let level = UIDevice.current.batteryLevel
        if level >= 0 {
            actualBatteryLevel = Int((level * 100).rounded())
        }
        batteryIsCharging = UIDevice.current.batteryState == .charging
            || UIDevice.current.batteryState == .full
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                batteryLevelCard
                autoBrightnessCard
                dailySummaryCard
                healthCard
                settingsTogglesCard
                Text("Battery percentage is read from this device. App usage charts and battery health details are illustrative because iOS does not expose those statistics to ordinary apps.")
                    .font(.footnote)
                    .foregroundStyle(BatteryPalette.muted)
                    .padding(.horizontal, 22)
                    .padding(.bottom, 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 12)
        }
        .background(BatteryPalette.background.ignoresSafeArea())
        .navigationTitle("Battery")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .onAppear(perform: refreshBatteryStatus)
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.batteryLevelDidChangeNotification)) { _ in
            refreshBatteryStatus()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.batteryStateDidChangeNotification)) { _ in
            refreshBatteryStatus()
        }
    }

    private var batteryLevelCard: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("\(actualBatteryLevel)")
                    .font(.system(size: 32, weight: .regular))
                Text("%").font(.system(size: 17))
                Spacer()
                Image(systemName: "info.circle")
                    .font(.system(size: 13))
                    .foregroundStyle(BatteryPalette.muted)
            }

            HStack(spacing: 4) {
                Image(systemName: batteryIsCharging ? "bolt.fill" : "battery.100")
                    .font(.system(size: 11, weight: .semibold))
                Text(batteryIsCharging ? "Slow Charger" : "Battery Level")
                    .font(.system(size: 12, weight: .medium))
                Spacer()
                Text("90%     100%")
                    .font(.system(size: 10))
                    .foregroundStyle(BatteryPalette.muted)
            }
            .foregroundStyle(batteryIsCharging ? Color.orange : BatteryPalette.muted)

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.white.opacity(0.12))
                    Capsule()
                        .fill(batteryIsCharging ? Color.orange : Color.white.opacity(0.62))
                        .frame(width: proxy.size.width * CGFloat(actualBatteryLevel) / 100)
                }
            }
            .frame(height: 5)

            HStack {
                Text(batteryIsCharging ? "1h+" : " ")
                Spacer()
                Text(batteryIsCharging ? "2h+" : " ")
            }
            .font(.system(size: 10))
            .foregroundStyle(BatteryPalette.muted)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 13)
        .background(BatteryPalette.card, in: RoundedRectangle(cornerRadius: 23, style: .continuous))
        .padding(.horizontal, 20)
    }

    private var autoBrightnessCard: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "sun.max.fill")
                .font(.system(size: 18)).foregroundStyle(BatteryPalette.blue)
                .frame(width: 32, height: 32)
                .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 9))
            VStack(alignment: .leading, spacing: 7) {
                HStack {
                    Text("Auto-Brightness").font(.system(size: 16, weight: .medium)).foregroundStyle(.white)
                    Spacer()
                    Image(systemName: "chevron.right").font(.system(size: 12, weight: .semibold)).foregroundStyle(BatteryPalette.muted)
                }
                Text("Auto-Brightness is currently turned off. You can save battery by turning it on.")
                    .font(.system(size: 12)).foregroundStyle(BatteryPalette.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(BatteryPalette.card, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.horizontal, 20)
    }

    private var dailySummaryCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Daily Usage")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(BatteryPalette.muted)
                .padding(.horizontal, 20)
                .padding(.bottom, 12)

            VStack(alignment: .leading, spacing: 17) {
                TimelineView(.periodic(from: .now, by: 60)) { context in
                    Text("You're using more battery today than you usually do by "
                         + context.date.formatted(Date.FormatStyle(date: .omitted, time: .shortened)) + ".")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Rectangle().fill(BatteryPalette.separator).frame(height: 1)

                HStack(alignment: .firstTextBaseline, spacing: 42) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Average")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(BatteryPalette.muted)
                        Text("8%")
                            .font(.system(size: 28, weight: .regular))
                            .foregroundStyle(BatteryPalette.muted)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Today")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.orange)
                        Text("16%")
                            .font(.system(size: 28, weight: .regular))
                            .foregroundStyle(Color.orange)
                    }
                    Spacer(minLength: 0)
                }

                BatteryOverviewWeekChart()
                    .frame(height: 175)

                HStack(spacing: 14) {
                    HStack(spacing: 6) {
                        Circle().fill(Color.white.opacity(0.20)).frame(width: 9, height: 9)
                        Text("All Day")
                    }
                    HStack(spacing: 6) {
                        Circle().fill(Color.white.opacity(0.34)).frame(width: 9, height: 9)
                        TimelineView(.periodic(from: .now, by: 60)) { context in
                            Text("Daily by " + context.date.formatted(Date.FormatStyle(date: .omitted, time: .shortened)))
                        }
                    }
                    Spacer(minLength: 0)
                }
                .font(.system(size: 12))
                .foregroundStyle(BatteryPalette.muted)

                BatteryTimelineChart(values: [0.08,0.14,0.35,0.45,0.47,0.47,0.46,0.46,0.45,0.45,0.46,0.54,0.42,0.18,0.26,0.50,0.47,0.49,0.59,0.75,0.82,0.64,0.45])
                    .frame(height: 150)

                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Screen On").foregroundStyle(BatteryPalette.muted)
                        Text("1h 7m").font(.system(size: 25)).foregroundStyle(.white)
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Screen Off").foregroundStyle(BatteryPalette.muted)
                        Text("1m").font(.system(size: 25)).foregroundStyle(.white)
                    }
                    .frame(width: 120, alignment: .leading)
                }
                .font(.system(size: 15))

                Rectangle().fill(BatteryPalette.separator).frame(height: 1)

                Text("App and System Activity")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(BatteryPalette.muted)

                ForEach(Array(BatteryDemoApp.all.prefix(3))) { app in
                    NavigationLink { BatteryAppDetailView(app: app) } label: {
                        BatteryAppRow(app: app, compact: false)
                    }
                    .buttonStyle(.plain)
                    .padding(.leading, -10)
                    Rectangle().fill(BatteryPalette.separator).frame(height: 1).padding(.leading, 50)
                }

                NavigationLink { BatteryUsageDetailView() } label: {
                    HStack {
                        Text("View All Battery Usage")
                            .font(.system(size: 16))
                            .foregroundStyle(BatteryPalette.blue)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(BatteryPalette.muted)
                    }
                    .padding(.top, 8)
                }
            }
            .padding(18)
            .background(BatteryPalette.card, in: RoundedRectangle(cornerRadius: 27, style: .continuous))
            .padding(.horizontal, 20)
        }
    }

    private var appAndSystemActivityCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("App and System Activity")
                .font(.system(size: 17, weight: .semibold)).foregroundStyle(.white)
                .padding(.horizontal, 18).padding(.top, 17)
            Text("See how much battery has been used by apps and system activity.")
                .font(.system(size: 12)).foregroundStyle(BatteryPalette.muted)
                .padding(.horizontal, 18).padding(.top, 6).padding(.bottom, 8)
            ForEach(Array(BatteryDemoApp.all.prefix(3))) { app in
                NavigationLink { BatteryAppDetailView(app: app) } label: {
                    BatteryAppRow(app: app, compact: true)
                }
                .buttonStyle(.plain)
                if app.id != BatteryDemoApp.all.prefix(3).last?.id {
                    Rectangle().fill(BatteryPalette.separator).frame(height: 1).padding(.leading, 72)
                }
            }
            NavigationLink { BatteryUsageDetailView() } label: {
                HStack {
                    Text("View All Battery Usage").font(.system(size: 14)).foregroundStyle(BatteryPalette.blue)
                    Spacer()
                    Image(systemName: "chevron.right").font(.system(size: 12, weight: .semibold)).foregroundStyle(BatteryPalette.muted)
                }
                .padding(.horizontal, 18).padding(.vertical, 15)
            }
        }
        .background(BatteryPalette.card, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .padding(.horizontal, 20)
    }

    private var healthCard: some View {
        NavigationLink { BatteryHealthDetailView() } label: {
            HStack(spacing: 10) {
                Text("Battery Health & Charging")
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                Spacer(minLength: 8)
                Text("Service")
                    .font(.system(size: 15))
                    .foregroundStyle(BatteryPalette.muted)
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(BatteryPalette.muted)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 20)
            .background(BatteryPalette.card, in: RoundedRectangle(cornerRadius: 25, style: .continuous))
            .padding(.horizontal, 20)
        }
        .buttonStyle(.plain)
    }

    private var settingsTogglesCard: some View {
        VStack(spacing: 0) {
            Toggle("Battery Percentage", isOn: $batteryPercentage)
                .tint(BatteryPalette.green).padding(.horizontal, 18).padding(.vertical, 13)
            Rectangle().fill(BatteryPalette.separator).frame(height: 1).padding(.leading, 18)
            Toggle("Low Power Mode", isOn: $lowPowerMode)
                .tint(BatteryPalette.green).padding(.horizontal, 18).padding(.vertical, 13)
        }
        .font(.system(size: 15))
        .background(BatteryPalette.card, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.horizontal, 20)
    }
}

private struct BatteryOverviewWeekChart: View {
    private let allDay: [CGFloat] = [0.73, 0.98, 0.60, 0.84, 0.56, 0.76, 0.61, 0.34]
    private let dailySoFar: [CGFloat] = [0.48, 0.69, 0.35, 0.58, 0.36, 0.42, 0.41, 0.30]
    private let days = ["M", "T", "W", "T", "F", "S", "S", "M"]

    // Narrow, left-aligned columns with a fixed label row underneath.
    private let barWidth: CGFloat = 12
    private let barSpacing: CGFloat = 15

    var body: some View {
        GeometryReader { proxy in
            let labelHeight: CGFloat = 27
            let plotHeight = proxy.size.height - labelHeight
            let chartWidth = barWidth * CGFloat(days.count) + barSpacing * CGFloat(days.count - 1)

            ZStack(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .bottom, spacing: barSpacing) {
                        ForEach(0..<days.count, id: \.self) { index in
                            ZStack(alignment: .bottom) {
                                if index != 7 {
                                    RoundedRectangle(cornerRadius: 7, style: .continuous)
                                        .fill(Color.white.opacity(0.13))
                                        .frame(width: barWidth, height: max(4, plotHeight * allDay[index] * 0.90))
                                }
                                RoundedRectangle(cornerRadius: 7, style: .continuous)
                                    .fill(index == 7
                                          ? LinearGradient(colors: [BatteryPalette.blue, Color(red: 0.02, green: 0.42, blue: 0.82)], startPoint: .top, endPoint: .bottom)
                                          : LinearGradient(colors: [Color.white.opacity(0.34), Color.white.opacity(0.23)], startPoint: .top, endPoint: .bottom))
                                    .frame(width: barWidth, height: max(4, plotHeight * dailySoFar[index] * 0.90))
                            }
                            .frame(width: barWidth, height: plotHeight, alignment: .bottom)
                        }
                    }
                    .frame(width: chartWidth, height: plotHeight, alignment: .bottomLeading)

                    HStack(spacing: barSpacing) {
                        ForEach(0..<days.count, id: \.self) { index in
                            Text(days[index])
                                .font(.system(size: 13, weight: index == 7 ? .medium : .regular))
                                .foregroundStyle(index == 7 ? BatteryPalette.blue : BatteryPalette.muted)
                                .frame(width: barWidth, alignment: .center)
                        }
                    }
                    .frame(width: chartWidth, height: labelHeight, alignment: .topLeading)
                }
                .padding(.leading, 0)
                .frame(height: proxy.size.height, alignment: .bottomLeading)

                let averageY = plotHeight * 0.60
                Path { path in
                    path.move(to: CGPoint(x: 0, y: averageY))
                    path.addLine(to: CGPoint(x: proxy.size.width, y: averageY))
                }
                .stroke(Color.white.opacity(0.14), lineWidth: 1)

                Text("Average")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(BatteryPalette.muted)
                    .padding(.horizontal, 5)
                    .background(BatteryPalette.card)
                    .position(x: proxy.size.width - 36, y: averageY - 13)
            }
        }
    }
}

private struct MiniWeekChart: View {
    private let values: [CGFloat] = [0.48, 0.75, 0.38, 0.64, 0.30, 0.53, 0.42]
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    ForEach(0..<3, id: \.self) { _ in
                        Rectangle().fill(Color.white.opacity(0.13)).frame(height: 0.7)
                        Spacer(minLength: 0)
                    }
                }
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(Array(values.enumerated()), id: \.offset) { index, value in
                        RoundedRectangle(cornerRadius: 3, style: .continuous)
                            .fill(index == 6 ? BatteryPalette.blue : Color.white.opacity(0.22))
                            .frame(maxWidth: .infinity).frame(height: proxy.size.height * value)
                    }
                }
                Rectangle().fill(Color.white.opacity(0.14)).frame(height: 1)
            }
        }
    }
}

private struct BatteryUsageDetailView: View {
    @State private var showAllApps = false
    @State private var selectedDay = 6
    private let apps = BatteryDemoApp.all
    private let weekly: [CGFloat] = [0.68, 0.83, 0.48, 0.75, 0.45, 0.64, 0.43, 0.0]
    private let hourly: [CGFloat] = [0.08,0.14,0.35,0.45,0.47,0.47,0.46,0.46,0.45,0.45,0.46,0.54,0.42,0.18,0.26,0.50,0.47,0.49,0.59,0.75,0.82,0.64,0.45]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Daily Usage").font(.system(size: 21, weight: .semibold)).foregroundStyle(BatteryPalette.muted).padding(.horizontal, 20).padding(.top, 5)
                VStack(alignment: .leading, spacing: 17) {
                    Text("You used less battery on Sunday than you usually do.").font(.system(size: 16, weight: .semibold)).foregroundStyle(.white)
                    Rectangle().fill(BatteryPalette.separator).frame(height: 1)
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(selectedDay == 6 ? "109%" : ["72%", "164%", "119%", "148%", "91%", "132%", "109%"][selectedDay])
                            .font(.system(size: 37)).foregroundStyle(BatteryPalette.blue)
                        Text(selectedDay == 6 ? "18 Oct 2026" : "Selected Day")
                            .font(.system(size: 16)).foregroundStyle(BatteryPalette.muted)
                    }.frame(maxWidth: .infinity, alignment: .trailing).padding(.trailing, 70)
                    WeeklyUsageColumns(values: weekly, selectedDay: $selectedDay)
                        .frame(height: 218)
                    HStack(spacing: 14) {
                        legendDot("All Day")
                        legendDot("Usage by End of Day")
                    }.font(.system(size: 12)).foregroundStyle(BatteryPalette.muted)
                    BatteryTimelineChart(values: hourly).frame(height: 175)
                    Rectangle().fill(BatteryPalette.separator).frame(height: 1).padding(.top, 3)
                    HStack {
                        VStack(alignment: .leading, spacing: 5) { Text("Screen On").foregroundStyle(BatteryPalette.muted); Text("5h 7m").font(.system(size: 25)).foregroundStyle(.white) }
                        Spacer()
                        VStack(alignment: .leading, spacing: 5) { Text("Screen Off").foregroundStyle(BatteryPalette.muted); Text("38m").font(.system(size: 25)).foregroundStyle(.white) }.frame(width: 140, alignment: .leading)
                    }.font(.system(size: 15))
                }
                .padding(19).background(BatteryPalette.card, in: RoundedRectangle(cornerRadius: 28, style: .continuous)).padding(.horizontal, 20)

                VStack(alignment: .leading, spacing: 0) {
                    Text("App and System Activity Usage").font(.system(size: 18, weight: .semibold)).foregroundStyle(.white).padding(.horizontal, 20).padding(.top, 6)
                    Text("Get an idea of how much battery has been used by apps and system activity.").font(.system(size: 12)).foregroundStyle(BatteryPalette.muted).padding(.horizontal, 20).padding(.vertical, 8)
                    VStack(spacing: 0) {
                        ForEach(showAllApps ? apps : Array(apps.prefix(4))) { app in
                            NavigationLink { BatteryAppDetailView(app: app) } label: { BatteryAppRow(app: app, compact: false) }.buttonStyle(.plain)
                            Rectangle().fill(BatteryPalette.separator).frame(height: 1).padding(.leading, 71)
                        }
                        Button { withAnimation(.easeInOut(duration: 0.2)) { showAllApps.toggle() } } label: {
                            HStack { Text(showAllApps ? "Show Less" : "Show More"); Spacer() }.font(.system(size: 16)).foregroundStyle(BatteryPalette.blue).padding(20)
                        }.buttonStyle(.plain)
                    }
                }
                .background(BatteryPalette.card, in: RoundedRectangle(cornerRadius: 27, style: .continuous)).padding(.horizontal, 20)
                VStack(alignment: .leading, spacing: 0) {
                    Text("Other Battery Usage").font(.system(size: 16)).foregroundStyle(BatteryPalette.muted).padding(18)
                    NavigationLink { BatteryAppDetailView(app: .init(id: "home", name: "Home & Lock Screen", asset: "", percent: 1, screen: "31m", background: nil)) } label: {
                        HStack(spacing: 13) {
                            Image(systemName: "iphone").font(.system(size: 23)).foregroundStyle(BatteryPalette.blue).frame(width: 45, height: 45).background(Color.black, in: RoundedRectangle(cornerRadius: 10))
                            VStack(alignment: .leading, spacing: 4) { Text("Home & Lock Screen").foregroundStyle(.white); Text("On screen: 31m").font(.system(size: 13)).foregroundStyle(BatteryPalette.muted) }
                            Spacer(); Text("1%").foregroundStyle(BatteryPalette.muted); Image(systemName: "chevron.right").foregroundStyle(BatteryPalette.muted)
                        }.font(.system(size: 16)).padding(18)
                    }.buttonStyle(.plain)
                }.background(BatteryPalette.card, in: RoundedRectangle(cornerRadius: 26, style: .continuous)).padding(.horizontal, 20)
                Text("Demonstration statistics only.").font(.footnote).foregroundStyle(BatteryPalette.muted).padding(.horizontal, 22).padding(.bottom, 20)
            }.padding(.top, 8)
        }
        .background(BatteryPalette.background.ignoresSafeArea())
        .navigationTitle("Battery Usage").navigationBarTitleDisplayMode(.inline).preferredColorScheme(.dark)
    }

    private func legendDot(_ title: String) -> some View {
        HStack(spacing: 5) { Circle().fill(Color.white.opacity(0.28)).frame(width: 9, height: 9); Text(title) }
    }
}

private struct WeeklyUsageColumns: View {
    let values: [CGFloat]
    @Binding var selectedDay: Int
    private let days = ["M", "T", "W", "T", "F", "S", "S", "M"]
    private let labels = ["72%", "164%", "119%", "148%", "91%", "132%", "109%", "0%"]

    var body: some View {
        GeometryReader { proxy in
            let axisWidth: CGFloat = 42
            let labelsHeight: CGFloat = 27
            let plotHeight = proxy.size.height - labelsHeight - 12
            let plotWidth = proxy.size.width - axisWidth
            ZStack(alignment: .topLeading) {
                // iOS-style horizontal percentage grid.
                ForEach(0..<3, id: \.self) { line in
                    let y = plotHeight * CGFloat(line) / 2
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: plotWidth, y: y))
                    }
                    .stroke(Color.white.opacity(0.19), lineWidth: 0.8)
                }
                HStack(alignment: .bottom, spacing: 6) {
                    ForEach(0..<8, id: \.self) { i in
                        VStack(spacing: 6) {
                            Spacer(minLength: 0)
                            Button { if i < 7 { selectedDay = i } } label: {
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(i == selectedDay
                                          ? AnyShapeStyle(BatteryPalette.blue)
                                          : AnyShapeStyle(LinearGradient(colors: [Color(white: 0.43), Color(white: 0.27)], startPoint: .top, endPoint: .bottom)))
                                    .frame(height: max(2, plotHeight * values[i]))
                            }
                            .buttonStyle(.plain)
                            Text(days[i])
                                .font(.system(size: 13, weight: .regular))
                                .foregroundStyle(i == selectedDay ? BatteryPalette.blue : BatteryPalette.muted)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(width: plotWidth, height: plotHeight + labelsHeight, alignment: .bottom)
                VStack {
                    Text("200%")
                    Spacer()
                    Text("100%")
                    Spacer()
                    Text("0%")
                }
                .font(.system(size: 12))
                .foregroundStyle(BatteryPalette.muted)
                .frame(width: axisWidth - 3, height: plotHeight, alignment: .leading)
                .position(x: plotWidth + axisWidth / 2, y: plotHeight / 2)
                Text("12/10")
                    .font(.system(size: 12))
                    .foregroundStyle(BatteryPalette.muted)
                    .position(x: 19, y: plotHeight + labelsHeight + 5)
            }
        }
    }
}

private struct BatteryTimelineChart: View {
    let values: [CGFloat]
    // Hour ranges during which the demo device is shown charging.
    private let chargingRanges: [ClosedRange<Int>] = [0...3, 7...9, 10...21]
    private let boltHours: [Int] = [2, 8, 15]

    var body: some View {
        VStack(spacing: 8) {
            GeometryReader { proxy in
                let plotHeight = proxy.size.height - 4
                ZStack(alignment: .bottomLeading) {
                    // Soft background blocks make charging periods distinct, as in the reference.
                    ForEach(Array(chargingRanges.enumerated()), id: \.offset) { _, range in
                        let startX = proxy.size.width * CGFloat(range.lowerBound) / CGFloat(values.count)
                        let width = proxy.size.width * CGFloat(range.count) / CGFloat(values.count)
                        Rectangle()
                            .fill(BatteryPalette.green.opacity(0.18))
                            .frame(width: width, height: plotHeight * 0.78)
                            .position(x: startX + width / 2, y: plotHeight * 0.61)
                    }
                    // Percentage guide lines.
                    VStack(spacing: 0) {
                        ForEach(0..<3, id: \.self) { _ in
                            Rectangle().fill(Color.white.opacity(0.18)).frame(height: 0.8)
                            Spacer(minLength: 0)
                        }
                    }
                    .frame(height: plotHeight * 0.88)
                    .frame(maxHeight: .infinity, alignment: .top)
                    HStack(alignment: .bottom, spacing: 2) {
                        ForEach(Array(values.enumerated()), id: \.offset) { index, value in
                            RoundedRectangle(cornerRadius: 2, style: .continuous)
                                .fill(barColor(index))
                                .frame(maxWidth: .infinity)
                                .frame(height: max(3, (plotHeight * 0.78) * value))
                        }
                    }
                    .frame(height: plotHeight * 0.78, alignment: .bottom)
                    // Charging level segments, deliberately separated rather than one continuous bar.
                    ForEach(Array(chargingRanges.enumerated()), id: \.offset) { _, range in
                        let startX = proxy.size.width * CGFloat(range.lowerBound) / CGFloat(values.count) + 1
                        let width = proxy.size.width * CGFloat(range.count) / CGFloat(values.count) - 2
                        Capsule()
                            .fill(BatteryPalette.green)
                            .frame(width: max(5, width), height: 5)
                            .position(x: startX + width / 2, y: plotHeight * 0.13)
                    }
                    ForEach(boltHours, id: \.self) { hour in
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 17, weight: .black))
                            .foregroundStyle(.black)
                            .padding(2)
                            .background(BatteryPalette.green, in: Circle())
                            .position(x: proxy.size.width * (CGFloat(hour) + 0.5) / CGFloat(values.count), y: plotHeight * 0.13)
                    }
                }
            }
            HStack {
                Text("00"); Spacer(); Text("06"); Spacer(); Text("12"); Spacer(); Text("18"); Spacer()
            }
            .font(.system(size: 12))
            .foregroundStyle(BatteryPalette.muted)
        }
    }

    private func barColor(_ index: Int) -> Color {
        // Yellow bars represent discharge; green bars correspond to charging/recovery periods.
        if [4, 5, 6, 9, 21, 22].contains(index) { return BatteryPalette.yellow }
        if chargingRanges.contains(where: { $0.contains(index) }) { return BatteryPalette.green }
        return Color(white: 0.34)
    }
}

private struct BatteryAppRow: View {
    let app: BatteryDemoApp
    let compact: Bool
    var body: some View {
        HStack(spacing: 13) {
            Group {
                if app.asset.isEmpty {
                    Image(systemName: "iphone").resizable().scaledToFit().padding(8).foregroundStyle(BatteryPalette.blue).background(Color.black, in: RoundedRectangle(cornerRadius: 10))
                } else {
                    Image(app.asset).resizable().scaledToFit().clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous)).overlay(RoundedRectangle(cornerRadius: 11).stroke(Color.white.opacity(0.16), lineWidth: 0.7))
                }
            }.frame(width: compact ? 38 : 48, height: compact ? 38 : 48)
            VStack(alignment: .leading, spacing: 3) {
                Text(app.name).font(.system(size: compact ? 15 : 17)).foregroundStyle(.white)
                Text("On screen: \(app.screen)").font(.system(size: compact ? 12 : 14)).foregroundStyle(BatteryPalette.muted)
                if let background = app.background { Text("Background: \(background)").font(.system(size: compact ? 12 : 14)).foregroundStyle(BatteryPalette.muted) }
            }
            Spacer(minLength: 4)
            Text("\(app.percent)%").font(.system(size: compact ? 14 : 17)).foregroundStyle(BatteryPalette.muted)
            Image(systemName: "chevron.right").font(.system(size: 13, weight: .semibold)).foregroundStyle(Color.white.opacity(0.35))
        }.padding(.leading, 0).padding(.trailing, 10).padding(.vertical, compact ? 12 : 17)
    }
}

private struct BatteryHealthDetailView: View {
    @State private var optimizedCharging = true
    @State private var actualBatteryLevel: Int = 0
    @State private var batteryIsCharging = false

    private func refreshBatteryStatus() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let level = UIDevice.current.batteryLevel
        if level >= 0 {
            actualBatteryLevel = Int((level * 100).rounded())
        }
        batteryIsCharging = UIDevice.current.batteryState == .charging
            || UIDevice.current.batteryState == .full
    }
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Important Battery Message").font(.system(size: 17, weight: .semibold)).foregroundStyle(.white)
                    Text("Your battery's health is significantly degraded. An Apple Authorized Service Provider can replace the battery to restore full performance and capacity.")
                        .font(.system(size: 14)).foregroundStyle(BatteryPalette.muted)
                    Button("Find Your Service Options") {}.font(.system(size: 14)).foregroundStyle(BatteryPalette.blue).padding(.top, 3)
                }.padding(18).frame(maxWidth: .infinity, alignment: .leading).background(BatteryPalette.card, in: RoundedRectangle(cornerRadius: 20))
                VStack(alignment: .leading, spacing: 14) {
                    Text("Maximum Capacity").font(.system(size: 17, weight: .semibold)).foregroundStyle(.white)
                    HStack(alignment: .firstTextBaseline) { Spacer(); Text("73%").font(.system(size: 27)).foregroundStyle(.white) }
                    Text("This is a measure of battery capacity relative to when it was new. A lower capacity may result in fewer hours of usage between charges.")
                        .font(.system(size: 13)).foregroundStyle(BatteryPalette.muted)
                }.padding(18).background(BatteryPalette.card, in: RoundedRectangle(cornerRadius: 20))
                VStack(alignment: .leading, spacing: 10) {
                    Text("Peak Performance Capability").font(.system(size: 17, weight: .semibold)).foregroundStyle(.white)
                    Text("Built-in dynamic software and hardware systems help counter performance impacts that may be noticed as the battery chemically ages.").font(.system(size: 13)).foregroundStyle(BatteryPalette.muted)
                }.padding(18).background(BatteryPalette.card, in: RoundedRectangle(cornerRadius: 20))
                Toggle(isOn: $optimizedCharging) { VStack(alignment: .leading, spacing: 4) { Text("Optimised Battery Charging").foregroundStyle(.white); Text("To reduce battery ageing, iPhone learns from your daily charging routine.").font(.system(size: 12)).foregroundStyle(BatteryPalette.muted) } }
                    .tint(BatteryPalette.green).padding(18).background(BatteryPalette.card, in: RoundedRectangle(cornerRadius: 20))
                Text("Battery health values are fictional demonstration data.").font(.footnote).foregroundStyle(BatteryPalette.muted)
            }.padding(20)
        }.background(BatteryPalette.background.ignoresSafeArea()).navigationTitle("Battery Health & Charging").navigationBarTitleDisplayMode(.inline).preferredColorScheme(.dark)
    }
}

private struct BatteryAppDetailView: View {
    let app: BatteryDemoApp
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) { Text("\(app.percent)%").font(.system(size: 32)).foregroundStyle(BatteryPalette.blue); Text("18 Oct 2026").font(.system(size: 15)).foregroundStyle(BatteryPalette.muted) }
                        Spacer()
                    }
                    MiniWeekChart().frame(height: 95)
                    HStack { Text("M       T       W       T       F       S       S"); Spacer() }.font(.system(size: 10)).foregroundStyle(BatteryPalette.muted)
                }.padding(18).background(BatteryPalette.card, in: RoundedRectangle(cornerRadius: 22))
                VStack(alignment: .leading, spacing: 16) {
                    Text("Activity").font(.system(size: 19, weight: .semibold)).foregroundStyle(.white)
                    HStack { VStack(alignment: .leading, spacing: 5) { Text("On Screen").foregroundStyle(BatteryPalette.muted); Text(app.screen).font(.system(size: 25)).foregroundStyle(.white) }; Spacer(); VStack(alignment: .leading, spacing: 5) { Text("Background").foregroundStyle(BatteryPalette.muted); Text(app.background ?? "0m").font(.system(size: 25)).foregroundStyle(.white) } }
                    Rectangle().fill(BatteryPalette.separator).frame(height: 1)
                    Text("About Activity").font(.system(size: 16, weight: .semibold)).foregroundStyle(.white)
                    Text("On Screen is the amount of time the app was active on screen. Background is the amount of time the app was active while not on screen.")
                        .font(.system(size: 13)).foregroundStyle(BatteryPalette.muted)
                    Text("These usage values are fictional demonstration data.").font(.system(size: 12)).foregroundStyle(BatteryPalette.muted)
                }.padding(18).background(BatteryPalette.card, in: RoundedRectangle(cornerRadius: 22))
            }.padding(20)
        }.background(BatteryPalette.background.ignoresSafeArea()).navigationTitle(app.name).navigationBarTitleDisplayMode(.inline).preferredColorScheme(.dark)
    }
}

#Preview {
    NavigationStack { BatteryView() }
        .preferredColorScheme(.dark)
}
