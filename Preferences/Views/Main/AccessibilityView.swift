//
//  AccessibilityView.swift
//  Settings
//
//  Accessibility / Touch / AssistiveTouch screens.
//

import SwiftUI
import UIKit

struct AccessibilityView: View {
    var body: some View {
        CustomList(title: "Accessibility") {
            Section {
                NavigationLink {
                    TouchSettingsView()
                } label: {
                    Label("Touch", systemImage: "hand.tap")
                }
            }

            Section {
                NavigationLink {
                    ControllerBridgeView(
                        "AccessibilitySettings",
                        controller: "AccessibilitySettingsController",
                        title: "More Accessibility Settings"
                    )
                } label: {
                    Label("More Accessibility Settings", systemImage: "accessibility")
                }
            }
        }
    }
}

// MARK: - Touch

private struct TouchSettingsView: View {
    @AppStorage("CustomAssistiveTouchEnabled") private var assistiveTouchEnabled = false
    @AppStorage("TouchReachabilityEnabled") private var reachabilityEnabled = false
    @AppStorage("TouchTapToWakeEnabled") private var tapToWakeEnabled = true

    var body: some View {
        CustomList(title: "Touch") {
            Section {
                NavigationLink {
                    AssistiveTouchSettingsView()
                } label: {
                    HStack {
                        Text("AssistiveTouch")
                        Spacer()
                        Text(assistiveTouchEnabled ? "On" : "Off")
                            .foregroundStyle(.secondary)
                    }
                }
            } footer: {
                VStack(alignment: .leading, spacing: 8) {
                    Text("AssistiveTouch allows you to use your iPhone if you have difficulty touching the screen or if you require an adaptive accessory.")
                    Link("What’s new in AssistiveTouch…", destination: URL(string: "https://support.apple.com/accessibility")!)
                }
            }

            Section {
                Toggle("Reachability", isOn: $reachabilityEnabled)
            } footer: {
                Text("Swipe down on the bottom edge of the screen to bring the top of the screen into reach.")
            }

            Section {
                NavigationLink("Haptic Touch") {
                    TouchHapticSettingsView()
                }
            } footer: {
                Text("Press on the display using a different length of time to reveal content previews, actions and contextual menus.")
            }

            Section {
                NavigationLink("Touch Accommodations") {
                    TouchAccommodationsSettingsView()
                }
            } footer: {
                Text("Adjust how the screen responds to touch.")
            }

            Section {
                Toggle("Tap to Wake", isOn: $tapToWakeEnabled)
            } footer: {
                Text("Wake the screen when you tap the display.")
            }
        }
    }
}

// MARK: - AssistiveTouch

private struct AssistiveTouchSettingsView: View {
    @AppStorage("CustomAssistiveTouchEnabled") private var enabled = false
    @AppStorage("CustomAssistiveTouchSingle") private var singleTap = "None"
    @AppStorage("CustomAssistiveTouchDouble") private var doubleTap = "None"
    @AppStorage("CustomAssistiveTouchLong") private var longPress = "None"

    var body: some View {
        CustomList(title: "AssistiveTouch") {
            Section {
                Toggle("AssistiveTouch", isOn: $enabled)
            } footer: {
                VStack(alignment: .leading, spacing: 8) {
                    Text("AssistiveTouch allows you to use your iPhone if you have difficulty touching the screen or if you require an adaptive accessory.")
                    Link("What’s new in AssistiveTouch…", destination: URL(string: "https://support.apple.com/accessibility")!)
                }
            }

            Section {
                NavigationLink("Customise Top Level Menu") {
                    AssistiveTopLevelMenuView()
                }
            }

            Section {
                actionRow("Single-Tap", selection: $singleTap)
                actionRow("Double-Tap", selection: $doubleTap)
                actionRow("Long Press", selection: $longPress)
            } header: {
                Text("Custom Actions")
            } footer: {
                Text("Custom actions allow you to interact directly with the AssistiveTouch icon without opening the menu.")
            }

            Section {
                NavigationLink("Create New Gesture…") {
                    AssistiveCustomGestureView()
                }
            } header: {
                Text("Custom Gestures")
            } footer: {
                Text("Custom gestures allow you to record touch gestures and play them back using AssistiveTouch.")
            }
        }
    }

    private func actionRow(_ title: String, selection: Binding<String>) -> some View {
        NavigationLink {
            AssistiveActionPickerView(title: title, selection: selection)
        } label: {
            HStack {
                Text(title)
                Spacer()
                Text(selection.wrappedValue)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private enum AssistiveAction: String, CaseIterable, Identifiable {
    case none = "None"
    case openMenu = "Open Menu"
    case passThrough = "Pass Through to App"
    case analytics = "Analytics"
    case appSwitcher = "App Switcher"
    case camera = "Camera"
    case controlCentre = "Control Centre"
    case darkMode = "Dark Mode"
    case frontCamera = "Front Camera"
    case holdAndDrag = "Hold and Drag"
    case home = "Home"
    case lockScreen = "Lock Screen"
    case lockRotation = "Lock Rotation"
    case notificationCentre = "Notification Centre"
    case screenshot = "Screenshot"
    case shake = "Shake"
    case siri = "Siri"
    case volumeDown = "Volume Down"
    case volumeUp = "Volume Up"

    var id: String { rawValue }
}

private struct AssistiveActionPickerView: View {
    let title: String
    @Binding var selection: String

    var body: some View {
        CustomList(title: title) {
            Section("System") {
                ForEach(AssistiveAction.allCases) { action in
                    Button {
                        selection = action.rawValue
                    } label: {
                        HStack {
                            Text(action.rawValue)
                            Spacer()
                            if selection == action.rawValue {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.tint)
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
    }
}

// MARK: - Top Level Menu and additional Touch screens

private struct AssistiveTopLevelMenuView: View {
    @AppStorage("AssistiveTouchTopLevelIconCount") private var iconCount = 6

    var body: some View {
        CustomList(title: "Customise Top Level Menu") {
            Section {
                Stepper("Icons: \(iconCount)", value: $iconCount, in: 1...8)
            } footer: {
                Text("Choose how many items are shown in the AssistiveTouch menu.")
            }
        }
    }
}

private struct AssistiveCustomGestureView: View {
    @State private var showingNotice = false

    var body: some View {
        CustomList(title: "Create New Gesture") {
            Section {
                Button("Start Recording") {
                    showingNotice = true
                }
            } footer: {
                Text("Gesture recording is not available in this app replica.")
            }
        }
        .alert("Custom Gestures", isPresented: $showingNotice) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("This screen is a visual replica. iOS does not provide third-party apps with the system gesture recorder.")
        }
    }
}

private struct TouchHapticSettingsView: View {
    @AppStorage("TouchHapticDuration") private var duration = "Default"

    var body: some View {
        CustomList(title: "Haptic Touch") {
            Section {
                Picker("Touch Duration", selection: $duration) {
                    Text("Fast").tag("Fast")
                    Text("Default").tag("Default")
                    Text("Slow").tag("Slow")
                }
            }
        }
    }
}

private struct TouchAccommodationsSettingsView: View {
    @AppStorage("TouchAccommodationsEnabled") private var enabled = false

    var body: some View {
        CustomList(title: "Touch Accommodations") {
            Section {
                Toggle("Touch Accommodations", isOn: $enabled)
            } footer: {
                Text("Adjust how the screen responds to touch.")
            }
        }
    }
}

// MARK: - Floating AssistiveTouch button

struct AssistiveTouchOverlay: View {
    @AppStorage("CustomAssistiveTouchEnabled") private var enabled = false
    @AppStorage("CustomAssistiveTouchSingle") private var singleTap = "None"
    @AppStorage("CustomAssistiveTouchDouble") private var doubleTap = "None"
    @AppStorage("CustomAssistiveTouchLong") private var longPress = "None"
    @AppStorage("AssistiveTouchDarkMode") private var darkModeEnabled = false

    @State private var committedOffset: CGSize = .zero
    @State private var liveOffset: CGSize = .zero
    @State private var showingMenu = false
    @State private var showingAnalytics = false
    @State private var actionMessage: String?

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                if enabled {
                    AssistiveTouchButton(
                        onSingleTap: { perform(singleTap) },
                        onDoubleTap: { perform(doubleTap) },
                        onLongPress: { perform(longPress) },
                        onDrag: { translation, ended in
                            if ended {
                                committedOffset.width += translation.width
                                committedOffset.height += translation.height
                                liveOffset = .zero
                            } else {
                                liveOffset = translation
                            }
                        }
                    )
                    .position(
                        x: min(max(geometry.size.width - 48 + committedOffset.width + liveOffset.width, 32), max(32, geometry.size.width - 32)),
                        y: min(max(geometry.size.height - 140 + committedOffset.height + liveOffset.height, 32), max(32, geometry.size.height - 32))
                    )
                    .transition(.opacity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.easeInOut(duration: 0.2), value: enabled)
        }
        .allowsHitTesting(enabled)
        .sheet(isPresented: $showingAnalytics) {
            NavigationStack {
                AnalyticsDataView()
            }
        }
        .sheet(isPresented: $showingMenu) {
            NavigationStack {
                List {
                    Section {
                        Button("Analytics") {
                            showingMenu = false
                            showingAnalytics = true
                        }
                        Button("Home") {
                            showingMenu = false
                            actionMessage = "Home is available inside the Settings app navigation."
                        }
                        Button("Dark Mode") {
                            darkModeEnabled.toggle()
                            showingMenu = false
                        }
                    }
                }
                .navigationTitle("AssistiveTouch")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") { showingMenu = false }
                    }
                }
            }
        }
        .alert("AssistiveTouch", isPresented: Binding(
            get: { actionMessage != nil },
            set: { if !$0 { actionMessage = nil } }
        )) {
            Button("OK", role: .cancel) { actionMessage = nil }
        } message: {
            Text(actionMessage ?? "")
        }
    }

    private func perform(_ action: String) {
        switch action {
        case "None", "Pass Through to App":
            break
        case "Open Menu":
            showingMenu = true
        case "Analytics":
            showingAnalytics = true
        case "Dark Mode":
            darkModeEnabled.toggle()
        case "Home":
            actionMessage = "The Home action cannot leave or control the iOS system from inside a regular app."
        default:
            actionMessage = "\(action) is an iOS system action. A regular app can display this option, but cannot execute that system action."
        }
    }
}

private struct AssistiveTouchButton: View {
    let onSingleTap: () -> Void
    let onDoubleTap: () -> Void
    let onLongPress: () -> Void
    let onDrag: (CGSize, Bool) -> Void

    var body: some View {
        ZStack {
            Circle()
                .fill(.ultraThinMaterial)
                .overlay(Circle().fill(Color.black.opacity(0.28)))
                .overlay(Circle().stroke(Color.white.opacity(0.68), lineWidth: 1.5))
                .shadow(color: .black.opacity(0.25), radius: 5, y: 2)

            Circle()
                .fill(Color.white.opacity(0.92))
                .frame(width: 15, height: 15)
        }
        .frame(width: 54, height: 54)
        .contentShape(Circle())
        .overlay {
            AssistiveTouchGestureSurface(
                onSingleTap: onSingleTap,
                onDoubleTap: onDoubleTap,
                onLongPress: onLongPress,
                onDrag: onDrag
            )
            .frame(width: 54, height: 54)
        }
        .accessibilityLabel("AssistiveTouch")
    }
}

private struct AssistiveTouchGestureSurface: UIViewRepresentable {
    let onSingleTap: () -> Void
    let onDoubleTap: () -> Void
    let onLongPress: () -> Void
    let onDrag: (CGSize, Bool) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true

        let singleTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleSingleTap))
        singleTap.numberOfTapsRequired = 1

        let doubleTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        singleTap.require(toFail: doubleTap)

        let longPress = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress(_:)))
        longPress.minimumPressDuration = 0.55

        let pan = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        pan.delegate = context.coordinator
        pan.maximumNumberOfTouches = 1

        view.addGestureRecognizer(singleTap)
        view.addGestureRecognizer(doubleTap)
        view.addGestureRecognizer(longPress)
        view.addGestureRecognizer(pan)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.parent = self
    }

    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var parent: AssistiveTouchGestureSurface

        init(parent: AssistiveTouchGestureSurface) {
            self.parent = parent
        }

        @objc func handleSingleTap() { parent.onSingleTap() }
        @objc func handleDoubleTap() { parent.onDoubleTap() }

        @objc func handleLongPress(_ recognizer: UILongPressGestureRecognizer) {
            if recognizer.state == .began { parent.onLongPress() }
        }

        @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
            let translation = recognizer.translation(in: recognizer.view)
            let offset = CGSize(width: translation.x, height: translation.y)
            switch recognizer.state {
            case .began, .changed:
                parent.onDrag(offset, false)
            case .ended, .cancelled, .failed:
                parent.onDrag(offset, true)
            default:
                break
            }
        }

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            true
        }
    }
}

#Preview {
    NavigationStack { AccessibilityView() }
}
