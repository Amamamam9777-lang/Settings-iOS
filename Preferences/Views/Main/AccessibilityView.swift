//
//  AccessibilityView.swift
//  Preferences
//
//  Settings > Accessibility
//

import SwiftUI

struct AccessibilityView: View {
    @AppStorage("SettingsAssistiveTouchOverlayEnabled") private var assistiveTouchOverlayEnabled = false

    var body: some View {
        ControllerBridgeView(
            "AccessibilitySettings",
            controller: "AccessibilitySettingsController",
            title: "Accessibility"
        )
        // Observe the existing native AssistiveTouch switch without replacing
        // Apple's settings screen or adding any extra rows or menus.
        .overlay {
            AssistiveTouchSwitchMonitor { isEnabled in
                assistiveTouchOverlayEnabled = isEnabled
            }
            .allowsHitTesting(false)
            .accessibilityHidden(true)
        }
    }
}

/// Reads the value of the existing UISwitch inside Apple's embedded
/// Accessibility settings controller. It does not create or modify controls.
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
        scheduleInitialRefreshes()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        refreshSwitchState()
    }

    private func scheduleInitialRefreshes() {
        // The private preferences controller can add its table rows after the
        // representable is attached, so retry briefly while that screen loads.
        for delay in [0.05, 0.2, 0.5, 1.0] {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.refreshSwitchState()
            }
        }
    }

    func refreshSwitchState() {
        guard let window else { return }

        var switches: [UISwitch] = []
        collectSwitches(in: window, into: &switches)
        let visibleSwitches = switches.filter {
            !$0.isHidden && $0.alpha > 0.01 && $0.bounds.width > 25 && $0.bounds.height > 15
        }

        // Prefer an explicitly labelled AssistiveTouch switch. On this native
        // pane it is normally the only visible switch, so that is the fallback.
        let target = visibleSwitches.first { candidate in
            let label = [candidate.accessibilityLabel, candidate.accessibilityIdentifier]
                .compactMap { $0 }
                .joined(separator: " ")
            return label.localizedCaseInsensitiveContains("assistivetouch")
                || label.localizedCaseInsensitiveContains("assistive touch")
        } ?? (visibleSwitches.count == 1 ? visibleSwitches.first : nil)

        guard let target, observedSwitch !== target else { return }
        observedSwitch?.removeTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        observedSwitch = target
        target.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        onChange?(target.isOn)
    }

    private func collectSwitches(in view: UIView, into result: inout [UISwitch]) {
        if let toggle = view as? UISwitch {
            result.append(toggle)
        }
        for child in view.subviews {
            collectSwitches(in: child, into: &result)
        }
    }

    @objc private func switchValueChanged(_ sender: UISwitch) {
        onChange?(sender.isOn)
    }
}

#Preview {
    NavigationStack {
        AccessibilityView()
    }
}
