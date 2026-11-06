//
//  AccessibilityView.swift
//  Preferences
//
//  Settings > Accessibility
//

import SwiftUI

/// The app's Accessibility pages are implemented locally so the AssistiveTouch
/// switch can control the in-app floating button. No extra menu or overlay menu
/// is presented.
struct AccessibilityView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    NavigationLink {
                        TouchSettingsView()
                    } label: {
                        AccessibilityNavigationRow(
                            symbol: "hand.tap",
                            title: "Touch"
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
                .padding(.top, 70)
            }
        }
        .navigationTitle("Accessibility")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TouchSettingsView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    NavigationLink {
                        AssistiveTouchSettingsView()
                    } label: {
                        AccessibilityNavigationRow(
                            symbol: "hand.tap",
                            title: "AssistiveTouch"
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
                .padding(.top, 70)
            }
        }
        .navigationTitle("Touch")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct AssistiveTouchSettingsView: View {
    @AppStorage("AssistiveTouchEnabled") private var assistiveTouchEnabled = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Text("AssistiveTouch")
                            .font(.system(size: 22, weight: .regular))
                            .foregroundStyle(.white)
                        Spacer()
                        Toggle("AssistiveTouch", isOn: $assistiveTouchEnabled)
                            .labelsHidden()
                            .tint(.white)
                    }
                    .padding(.horizontal, 22)
                    .padding(.vertical, 22)
                    .background(Color(white: 0.11), in: Capsule())

                    Text("AssistiveTouch allows you to use your iPhone if you have difficulty touching the screen or if you require an adaptive accessory.")
                        .font(.system(size: 15))
                        .foregroundStyle(.white.opacity(0.58))
                        .padding(.horizontal, 20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 70)
            }
        }
        .navigationTitle("AssistiveTouch")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct AccessibilityNavigationRow: View {
    let symbol: String
    let title: String

    var body: some View {
        HStack(spacing: 18) {
            Image(systemName: symbol)
                .font(.system(size: 25, weight: .regular))
                .foregroundStyle(Color.blue)
                .frame(width: 38)
            Text(title)
                .font(.system(size: 18))
                .foregroundStyle(.white)
            Spacer(minLength: 8)
            Image(systemName: "chevron.right")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white.opacity(0.32))
        }
        .padding(.horizontal, 22)
        .frame(height: 76)
        .background(Color(white: 0.11), in: Capsule())
        .contentShape(Capsule())
    }
}

#Preview {
    NavigationStack {
        AccessibilityView()
    }
}
