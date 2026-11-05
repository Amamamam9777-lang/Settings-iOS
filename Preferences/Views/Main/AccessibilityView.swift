//
//  AccessibilityView.swift
//  Settings
//

import SwiftUI
import UIKit

struct AccessibilityView: View {
    var body: some View {
        List {
            Section {
                NavigationLink {
                    CustomTouchSettingsView()
                } label: {
                    Label("Touch", systemImage: "hand.tap")
                }
            }
            Section {
                NavigationLink {
                    ControllerBridgeView(
                        "AccessibilitySettings",
                        controller: "AccessibilitySettingsController",
                        title: "Accessibility"
                    )
                } label: {
                    Label("More Accessibility Settings", systemImage: "accessibility")
                }
            }
        }
        .navigationTitle("Accessibility")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private enum AssistiveAction: String, CaseIterable, Identifiable {
    case none = "None"
    case menu = "Open Menu"
    case analytics = "Analytics"
    case home = "Go to Settings Home"
    case back = "Back"
    case toggle = "Toggle AssistiveTouch"

    var id: String { rawValue }
}

struct CustomTouchSettingsView: View {
    @AppStorage("CustomAssistiveTouchEnabled") private var enabled = false
    @AppStorage("CustomAssistiveTouchSingle") private var single = "Analytics"
    @AppStorage("CustomAssistiveTouchDouble") private var double = "None"
    @AppStorage("CustomAssistiveTouchLong") private var long = "None"

    var body: some View {
        List {
            Section {
                Toggle("AssistiveTouch", isOn: $enabled)
            } footer: {
                Text("A floating button appears inside this Settings app when AssistiveTouch is enabled.")
            }

            Section {
                actionPicker("Single-Tap", selection: $single)
                actionPicker("Double-Tap", selection: $double)
                actionPicker("Long Press", selection: $long)
            } header: {
                Text("Custom Actions")
            } footer: {
                Text("Choose what the floating button does. These actions work inside this app only.")
            }
        }
        .navigationTitle("AssistiveTouch")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func actionPicker(_ title: String, selection: Binding<String>) -> some View {
        NavigationLink {
            List {
                ForEach(AssistiveAction.allCases) { action in
                    Button { selection.wrappedValue = action.rawValue } label: {
                        HStack {
                            Text(action.rawValue)
                            Spacer()
                            if selection.wrappedValue == action.rawValue {
                                Image(systemName: "checkmark").foregroundStyle(.tint)
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .foregroundStyle(.primary)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        } label: {
            HStack { Text(title); Spacer(); Text(selection.wrappedValue).foregroundStyle(.secondary) }
        }
    }
}

struct AssistiveTouchOverlay: View {
    @AppStorage("CustomAssistiveTouchEnabled") private var enabled = false
    @AppStorage("CustomAssistiveTouchSingle") private var single = "Analytics"
    @AppStorage("CustomAssistiveTouchDouble") private var double = "None"
    @AppStorage("CustomAssistiveTouchLong") private var long = "None"
    @State private var showingAction = false
    @State private var actionTitle = ""
    @State private var dragOffset: CGSize = .zero

    var body: some View {
        if enabled {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "circle.grid.3x3.fill")
                        .font(.system(size: 23, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 58, height: 58)
                        .background(.ultraThinMaterial, in: Circle())
                        .overlay(Circle().stroke(.white.opacity(0.45), lineWidth: 1))
                        .shadow(color: .black.opacity(0.25), radius: 8, y: 3)
                        .contentShape(Circle())
                        .onTapGesture(count: 2) { run(double) }
                        .onTapGesture { run(single) }
                        .onLongPressGesture(minimumDuration: 0.55) { run(long) }
                        .offset(dragOffset)
                        .gesture(DragGesture().onChanged { dragOffset = $0.translation }.onEnded { _ in })
                        .padding(.trailing, 18)
                        .padding(.bottom, 34)
                }
            }
            .ignoresSafeArea()
            .alert(actionTitle, isPresented: $showingAction) { Button("OK", role: .cancel) {} }
            .allowsHitTesting(true)
        }
    }

    private func run(_ action: String) {
        guard action != "None" else { return }
        switch action {
        case "Toggle AssistiveTouch": enabled.toggle()
        case "Open Menu": actionTitle = "AssistiveTouch Menu"; showingAction = true
        case "Analytics": actionTitle = "Analytics"; showingAction = true
        case "Go to Settings Home": actionTitle = "Settings Home"; showingAction = true
        case "Back": actionTitle = "Back"; showingAction = true
        default: actionTitle = action; showingAction = true
        }
    }
}

#Preview {
    NavigationStack { AccessibilityView() }
}
