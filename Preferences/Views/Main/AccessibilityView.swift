//
//  AccessibilityView.swift
//  Preferences
//
//  Settings > Accessibility
//

import SwiftUI

struct AccessibilityView: View {
    var body: some View {
        CustomList(title: "Accessibility") {
            Section {
                SLink(
                    "Touch",
                    icon: "com.apple.graphic-icon.touch",
                    destination: TouchSettingsView()
                )
            }
        }
    }
}

/// The existing Accessibility > Touch path, with no additional rows or menus.
private struct TouchSettingsView: View {
    var body: some View {
        CustomList(title: "Touch") {
            Section {
                SLink(
                    "AssistiveTouch",
                    icon: "com.apple.graphic-icon.touch",
                    destination: AssistiveTouchSettingsView()
                )
            }
        }
    }
}

/// Reuses the original AssistiveTouch location and stores only its on/off state.
private struct AssistiveTouchSettingsView: View {
    @AppStorage("AssistiveTouchEnabled") private var isEnabled = false

    var body: some View {
        CustomList(title: "AssistiveTouch") {
            Section {
                Toggle("AssistiveTouch", isOn: $isEnabled)
            }

            Section {
                Text("AssistiveTouch allows you to use your iPhone if you have difficulty touching the screen or if you require an adaptive accessory.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .listRowBackground(Color.clear)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AccessibilityView()
    }
}
