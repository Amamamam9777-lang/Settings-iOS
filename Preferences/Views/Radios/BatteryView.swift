//
//  BatteryView.swift
//  Preferences
//
//  Demo Battery screen with fictional usage statistics.
//  All values shown here are local demo data and do not represent real device usage.
//

import SwiftUI

struct BatteryView: View {
    @State private var selectedPeriod = 0
    @State private var showAllApps = false

    private let appUsage: [(name: String, icon: String, tint: Color, percent: Int, detail: String)] = [
        ("TikTok", "music.note", .pink, 28, "1 hr 24 min On Screen"),
        ("Instagram", "camera", .purple, 21, "58 min On Screen"),
        ("YouTube", "play.rectangle.fill", .red, 17, "46 min On Screen"),
        ("Settings", "gearshape.fill", .gray, 9, "18 min On Screen"),
        ("Safari", "safari.fill", .blue, 8, "16 min On Screen"),
        ("Messages", "message.fill", .green, 6, "12 min On Screen"),
        ("Photos", "photo.fill", .cyan, 5, "9 min On Screen"),
        ("Other", "square.grid.2x2.fill", .secondary, 6, "Background activity")
    ]

    private var visibleApps: [(name: String, icon: String, tint: Color, percent: Int, detail: String)] {
        showAllApps ? appUsage : Array(appUsage.prefix(5))
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Battery Level")
                            .font(.headline)
                        Spacer()
                        Text(selectedPeriod == 0 ? "Last 24 Hours" : "Last 10 Days")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    HStack(alignment: .bottom, spacing: 4) {
                        ForEach(Array((selectedPeriod == 0 ? hourlyLevels : dailyLevels).enumerated()), id: \.offset) { index, value in
                            VStack(spacing: 3) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(value <= 20 ? Color.red : Color.green)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: CGFloat(value) * 1.25)
                                if selectedPeriod == 0 && index.isMultiple(of: 4) {
                                    Text(["00", "04", "08", "12", "16", "20"][min(index / 4, 5)])
                                        .font(.system(size: 9))
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .frame(height: 140, alignment: .bottom)

                    HStack {
                        Label("Charging", systemImage: "bolt.fill")
                        Spacer()
                        Text("Last Charged to 100% • 8:12 AM")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }

            Section {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Activity")
                            .font(.headline)
                        Spacer()
                        Text(selectedPeriod == 0 ? "Last 24 Hours" : "Last 10 Days")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    HStack(alignment: .bottom, spacing: 4) {
                        ForEach(Array((selectedPeriod == 0 ? hourlyActivity : dailyActivity).enumerated()), id: \.offset) { _, value in
                            VStack(spacing: 0) {
                                Spacer(minLength: 0)
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.blue)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: CGFloat(value) * 1.5)
                            }
                            .frame(height: 80)
                        }
                    }
                    HStack {
                        Label("Screen On", systemImage: "iphone")
                        Spacer()
                        Text(selectedPeriod == 0 ? "4 hr 18 min" : "31 hr 42 min")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Label("Screen Off", systemImage: "iphone.slash")
                        Spacer()
                        Text(selectedPeriod == 0 ? "1 hr 12 min" : "8 hr 35 min")
                            .foregroundStyle(.secondary)
                    }
                }
                .font(.subheadline)
                .padding(.vertical, 8)
            }

            Section {
                Picker("Period", selection: $selectedPeriod) {
                    Text("Last 24 Hours").tag(0)
                    Text("Last 10 Days").tag(1)
                }
                .pickerStyle(.segmented)
                .listRowBackground(Color.clear)
            }

            Section {
                ForEach(visibleApps, id: \.name) { app in
                    HStack(spacing: 12) {
                        Image(systemName: app.icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 34, height: 34)
                            .background(app.tint.gradient, in: RoundedRectangle(cornerRadius: 8))

                        VStack(alignment: .leading, spacing: 4) {
                            Text(app.name)
                                .foregroundStyle(.primary)
                            Text(app.detail)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer(minLength: 8)
                        VStack(alignment: .trailing, spacing: 5) {
                            Text("\(app.percent)%")
                                .foregroundStyle(.primary)
                            GeometryReader { proxy in
                                ZStack(alignment: .leading) {
                                    Capsule().fill(Color.secondary.opacity(0.18))
                                    Capsule().fill(Color.green).frame(width: proxy.size.width * CGFloat(app.percent) / 30)
                                }
                            }
                            .frame(width: 48, height: 4)
                        }
                    }
                    .padding(.vertical, 3)
                }

                Button(showAllApps ? "Show Less" : "Show More") {
                    withAnimation(.easeInOut) { showAllApps.toggle() }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            } header: {
                Text("Battery Usage by App")
            } footer: {
                Text("Demonstration data only. Battery levels and app activity are fictional and do not come from the device.")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Battery")
        .navigationBarTitleDisplayMode(.inline)
    }

    private let hourlyLevels: [Int] = [82, 80, 78, 75, 72, 68, 65, 61, 58, 54, 50, 46, 43, 40, 37, 33, 30, 27, 24, 22, 19, 17, 15, 13]
    private let dailyLevels: [Int] = [95, 82, 90, 68, 76, 55, 88, 72, 63, 79]
    private let hourlyActivity: [Int] = [5, 2, 1, 1, 2, 3, 6, 9, 14, 18, 24, 20, 16, 25, 30, 22, 17, 27, 21, 14, 8, 6, 3, 2]
    private let dailyActivity: [Int] = [28, 35, 24, 42, 31, 47, 38, 29, 45, 34]
}

#Preview {
    NavigationStack {
        BatteryView()
    }
}
