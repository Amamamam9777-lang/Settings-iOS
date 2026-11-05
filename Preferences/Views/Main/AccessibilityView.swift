//
//  AccessibilityView.swift
//  Preferences
//
//  Settings > Accessibility
//

import SwiftUI
import UIKit

struct AccessibilityView: View {
    @AppStorage("SettingsAssistiveTouchOverlayEnabled") private var assistiveTouchOverlayEnabled = false

    var body: some View {
        ControllerBridgeView(
            "AccessibilitySettings",
            controller: "AccessibilitySettingsController",
            title: "Accessibility"
        )
        // Watch the existing native switch as the Settings controller pushes
        // the Touch / AssistiveTouch pages. No rows, menus or screens are added.
        .overlay {
            AssistiveTouchSwitchMonitor { enabled in
                if assistiveTouchOverlayEnabled != enabled {
                    assistiveTouchOverlayEnabled = enabled
                }
            }
            .allowsHitTesting(false)
            .accessibilityHidden(true)
        }
    }
}

private struct AssistiveTouchSwitchMonitor: UIViewRepresentable {
    var onChange: (Bool) -> Void

    func makeUIView(context: Context) -> AssistiveTouchSwitchMonitorView {
        let view = AssistiveTouchSwitchMonitorView()
        view.onChange = onChange
        return view
    }

    func updateUIView(_ uiView: AssistiveTouchSwitchMonitorView, context: Context) {
        uiView.onChange = onChange
        uiView.refreshSwitchState()
    }
}

private final class AssistiveTouchSwitchMonitorView: UIView {
    var onChange: ((Bool) -> Void)?
    private weak var observedSwitch: UISwitch?
    private var pollingTimer: Timer?
    private var lastReportedValue: Bool?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
        isAccessibilityElement = false
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        isUserInteractionEnabled = false
        isAccessibilityElement = false
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil {
            startPolling()
        } else {
            pollingTimer?.invalidate()
            pollingTimer = nil
        }
    }

    deinit {
        pollingTimer?.invalidate()
    }

    private func startPolling() {
        guard pollingTimer == nil else { return }
        // The native Preferences controller pushes Touch and AssistiveTouch
        // inside its own navigation stack without necessarily relaying out
        // this SwiftUI overlay. Polling discovers the switch on those pages.
        pollingTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            self?.refreshSwitchState()
        }
        refreshSwitchState()
    }

    func refreshSwitchState() {
        guard window != nil else { return }

        let windows = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
        var switches: [UISwitch] = []
        for candidateWindow in windows {
            collectSwitches(in: candidateWindow, into: &switches)
        }

        let visible = switches.filter {
            !$0.isHidden && $0.alpha > 0.01 && $0.bounds.width > 25 && $0.bounds.height > 15
        }
        let target = visible.first { candidate in
            var labels: [String] = []
            var node: UIView? = candidate
            for _ in 0..<6 {
                guard let current = node else { break }
                if let label = current.accessibilityLabel { labels.append(label) }
                if let identifier = current.accessibilityIdentifier { labels.append(identifier) }
                node = current.superview
            }
            let combined = labels.joined(separator: " ")
            return combined.localizedCaseInsensitiveContains("assistivetouch")
                || combined.localizedCaseInsensitiveContains("assistive touch")
        } ?? (visible.count == 1 ? visible.first : nil)

        guard let target else { return }
        if observedSwitch !== target {
            observedSwitch?.removeTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
            observedSwitch = target
            target.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        }
        report(target.isOn)
    }

    private func collectSwitches(in view: UIView, into result: inout [UISwitch]) {
        if let toggle = view as? UISwitch { result.append(toggle) }
        for child in view.subviews { collectSwitches(in: child, into: &result) }
    }

    @objc private func switchValueChanged(_ sender: UISwitch) {
        report(sender.isOn)
    }

    private func report(_ value: Bool) {
        guard lastReportedValue != value else { return }
        lastReportedValue = value
        onChange?(value)
    }
}

#Preview {
    NavigationStack {
        AccessibilityView()
    }
}
