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
                SLink("Vision", icon: "eye", destination: AccessibilityCategoryView(title: "Vision", items: [
                    .init(title: "VoiceOver", subtitle: "Hear descriptions of what’s on your screen", icon: "voiceover", toggles: ["VoiceOverEnabled", "SpeakScreenEnabled"]),
                    .init(title: "Zoom", subtitle: "Magnify the screen", icon: "plus.magnifyingglass", toggles: ["ZoomEnabled"]),
                    .init(title: "Hover Text", subtitle: "Display enlarged text when using a pointer", icon: "text.magnifyingglass", toggles: ["HoverTextEnabled"]),
                    .init(title: "Display & Text Size", subtitle: "Adjust colors, text, and visibility", icon: "textformat.size", toggles: ["BoldTextEnabled", "LargerTextEnabled", "ButtonShapesEnabled", "ReduceTransparencyEnabled", "IncreaseContrastEnabled", "DifferentiateWithoutColorEnabled"]),
                    .init(title: "Motion", subtitle: "Reduce motion and animation", icon: "figure.walk.motion", toggles: ["ReduceMotionEnabled", "AutoPlayVideoPreviewsEnabled"]),
                    .init(title: "Spoken Content", subtitle: "Speak selection and screen content", icon: "text.bubble", toggles: ["SpeakSelectionEnabled", "SpeakScreenEnabled", "TypingFeedbackEnabled"]),
                    .init(title: "Audio Descriptions", subtitle: "Automatically play audio descriptions", icon: "waveform", toggles: ["AudioDescriptionsEnabled"])
                ]))
            }

            Section {
                SLink("Physical and Motor", icon: "hand.tap", destination: AccessibilityCategoryView(title: "Physical and Motor", items: [
                    .init(title: "Touch", subtitle: "Touch accommodations and interaction", icon: "hand.tap", toggles: ["TouchAccommodationsEnabled", "ShakeToUndoEnabled", "ReachabilityEnabled"]),
                    .init(title: "Face ID & Attention", subtitle: "Attention-aware features", icon: "faceid", toggles: ["AttentionAwareEnabled"]),
                    .init(title: "Switch Control", subtitle: "Control iPhone with switches", icon: "switch.2", toggles: ["SwitchControlEnabled"]),
                    .init(title: "Voice Control", subtitle: "Navigate and interact with your voice", icon: "mic", toggles: ["VoiceControlEnabled"]),
                    .init(title: "Siri", subtitle: "Type to Siri and adjust response settings", icon: " siri", toggles: ["TypeToSiriEnabled"]),
                    .init(title: "Side Button", subtitle: "Adjust side button interaction", icon: "button.vertical.right", toggles: ["SlowSideButtonEnabled"]),
                    .init(title: "Apple TV Remote", subtitle: "Control Apple TV with your device", icon: "appletvremote.gen4", toggles: ["AppleTVRemoteEnabled"])
                ]))
            }

            Section {
                SLink("Hearing", icon: "ear", destination: AccessibilityCategoryView(title: "Hearing", items: [
                    .init(title: "Hearing Devices", subtitle: "Pair and manage hearing devices", icon: "earbuds", toggles: ["HearingDevicesEnabled"]),
                    .init(title: "Sound Recognition", subtitle: "Get alerts for important sounds", icon: "waveform", toggles: ["SoundRecognitionEnabled"]),
                    .init(title: "Audio & Visual", subtitle: "Adjust audio and visual accessibility", icon: "speaker.wave.2", toggles: ["MonoAudioEnabled", "HeadphoneNotificationsEnabled", "LEDFlashAlertsEnabled"]),
                    .init(title: "Subtitles & Captioning", subtitle: "Customize subtitles and captions", icon: "captions.bubble", toggles: ["ClosedCaptionsEnabled"]),
                    .init(title: "Live Captions", subtitle: "Display real-time captions", icon: "quote.bubble", toggles: ["LiveCaptionsEnabled"])
                ]))
            }

            Section {
                SLink("Speech", icon: "waveform", destination: AccessibilityCategoryView(title: "Speech", items: [
                    .init(title: "Live Speech", subtitle: "Type what you want to say", icon: "text.bubble", toggles: ["LiveSpeechEnabled"]),
                    .init(title: "Personal Voice", subtitle: "Create a voice that sounds like you", icon: "person.wave.2", toggles: ["PersonalVoiceEnabled"]),
                    .init(title: "Vocal Shortcuts", subtitle: "Perform actions with custom sounds", icon: "waveform.badge.mic", toggles: ["VocalShortcutsEnabled"])
                ]))
            }

            Section {
                SLink("General", icon: "accessibility", destination: AccessibilityCategoryView(title: "General", items: [
                    .init(title: "Guided Access", subtitle: "Keep iPhone on a single app", icon: "lock", toggles: ["GuidedAccessEnabled"]),
                    .init(title: "Assistive Access", subtitle: "A simplified interface for iPhone", icon: "person.crop.circle", toggles: ["AssistiveAccessEnabled"]),
                    .init(title: "Siri", subtitle: "Accessibility options for Siri", icon: " siri", toggles: ["TypeToSiriEnabled"]),
                    .init(title: "Accessibility Shortcut", subtitle: "Choose features for the shortcut", icon: "triple.m", toggles: ["AccessibilityShortcutEnabled"])
                ]))
            }
        }
    }
}

private struct TouchSettingsView: View {
    var body: some View {
        CustomList(title: "Touch") {
            Section {
                SLink("AssistiveTouch", icon: "circle.circle", destination: AssistiveTouchSettingsView())
                SLink("Touch Accommodations", icon: "hand.tap", destination: AccessibilityFeatureDetailView(feature: .init(title: "Touch Accommodations", subtitle: "Adjust how the screen responds to touches", icon: "hand.tap", toggles: ["TouchAccommodationsEnabled"])))
                SLink("Reachability", icon: "arrow.down.to.line", destination: AccessibilityFeatureDetailView(feature: .init(title: "Reachability", subtitle: "Bring items at the top of the screen within reach", icon: "arrow.down.to.line", toggles: ["ReachabilityEnabled"])))
            }
        }
    }
}

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

private struct AccessibilityFeature: Identifiable {
    let title: String
    let subtitle: String
    let icon: String
    let toggles: [String]
    var id: String { title }
}

private struct AccessibilityCategoryView: View {
    let title: String
    let items: [AccessibilityFeature]

    var body: some View {
        CustomList(title: title) {
            ForEach(items) { item in
                Section {
                    NavigationLink {
                        if item.title == "Touch" {
                            TouchSettingsView()
                        } else {
                            AccessibilityFeatureDetailView(feature: item)
                        }
                    } label: {
                        Label {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(item.title)
                                Text(item.subtitle)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        } icon: {
                            Image(systemName: item.icon.trimmingCharacters(in: .whitespaces))
                                .foregroundStyle(.blue)
                                .frame(width: 28)
                        }
                    }
                }
            }
        }
    }
}

private struct AccessibilityFeatureDetailView: View {
    let feature: AccessibilityFeature
    @AppStorage("AssistiveTouchEnabled") private var assistiveTouchEnabled = false
    @AppStorage("VoiceOverEnabled") private var voiceOverEnabled = false
    @AppStorage("ZoomEnabled") private var zoomEnabled = false
    @AppStorage("BoldTextEnabled") private var boldTextEnabled = false
    @AppStorage("LargerTextEnabled") private var largerTextEnabled = false
    @AppStorage("ButtonShapesEnabled") private var buttonShapesEnabled = false
    @AppStorage("ReduceTransparencyEnabled") private var reduceTransparencyEnabled = false
    @AppStorage("IncreaseContrastEnabled") private var increaseContrastEnabled = false
    @AppStorage("DifferentiateWithoutColorEnabled") private var differentiateWithoutColorEnabled = false
    @AppStorage("ReduceMotionEnabled") private var reduceMotionEnabled = false
    @AppStorage("SpeakSelectionEnabled") private var speakSelectionEnabled = false
    @AppStorage("SpeakScreenEnabled") private var speakScreenEnabled = false
    @AppStorage("TouchAccommodationsEnabled") private var touchAccommodationsEnabled = false
    @AppStorage("SwitchControlEnabled") private var switchControlEnabled = false
    @AppStorage("VoiceControlEnabled") private var voiceControlEnabled = false
    @AppStorage("LiveSpeechEnabled") private var liveSpeechEnabled = false
    @AppStorage("SoundRecognitionEnabled") private var soundRecognitionEnabled = false
    @AppStorage("MonoAudioEnabled") private var monoAudioEnabled = false
    @AppStorage("LEDFlashAlertsEnabled") private var ledFlashAlertsEnabled = false
    @AppStorage("GuidedAccessEnabled") private var guidedAccessEnabled = false
    @AppStorage("AssistiveAccessEnabled") private var assistiveAccessEnabled = false
    @AppStorage("AccessibilityShortcutEnabled") private var accessibilityShortcutEnabled = false

    var body: some View {
        CustomList(title: feature.title) {
            Section {
                ForEach(feature.toggles, id: \.self) { key in
                    toggleRow(for: key)
                }
            }
            Section {
                Text(feature.subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .listRowBackground(Color.clear)
            }
        }
    }

    @ViewBuilder
    private func toggleRow(for key: String) -> some View {
        switch key {
        case "AssistiveTouchEnabled": Toggle("AssistiveTouch", isOn: $assistiveTouchEnabled)
        case "VoiceOverEnabled": Toggle("VoiceOver", isOn: $voiceOverEnabled)
        case "ZoomEnabled": Toggle("Zoom", isOn: $zoomEnabled)
        case "BoldTextEnabled": Toggle("Bold Text", isOn: $boldTextEnabled)
        case "LargerTextEnabled": Toggle("Larger Text", isOn: $largerTextEnabled)
        case "ButtonShapesEnabled": Toggle("Button Shapes", isOn: $buttonShapesEnabled)
        case "ReduceTransparencyEnabled": Toggle("Reduce Transparency", isOn: $reduceTransparencyEnabled)
        case "IncreaseContrastEnabled": Toggle("Increase Contrast", isOn: $increaseContrastEnabled)
        case "DifferentiateWithoutColorEnabled": Toggle("Differentiate Without Color", isOn: $differentiateWithoutColorEnabled)
        case "ReduceMotionEnabled": Toggle("Reduce Motion", isOn: $reduceMotionEnabled)
        case "SpeakSelectionEnabled": Toggle("Speak Selection", isOn: $speakSelectionEnabled)
        case "SpeakScreenEnabled": Toggle("Speak Screen", isOn: $speakScreenEnabled)
        case "TouchAccommodationsEnabled": Toggle("Touch Accommodations", isOn: $touchAccommodationsEnabled)
        case "SwitchControlEnabled": Toggle("Switch Control", isOn: $switchControlEnabled)
        case "VoiceControlEnabled": Toggle("Voice Control", isOn: $voiceControlEnabled)
        case "LiveSpeechEnabled": Toggle("Live Speech", isOn: $liveSpeechEnabled)
        case "SoundRecognitionEnabled": Toggle("Sound Recognition", isOn: $soundRecognitionEnabled)
        case "MonoAudioEnabled": Toggle("Mono Audio", isOn: $monoAudioEnabled)
        case "LEDFlashAlertsEnabled": Toggle("LED Flash for Alerts", isOn: $ledFlashAlertsEnabled)
        case "GuidedAccessEnabled": Toggle("Guided Access", isOn: $guidedAccessEnabled)
        case "AssistiveAccessEnabled": Toggle("Assistive Access", isOn: $assistiveAccessEnabled)
        case "AccessibilityShortcutEnabled": Toggle("Accessibility Shortcut", isOn: $accessibilityShortcutEnabled)
        default: Toggle(key.replacingOccurrences(of: "Enabled", with: ""), isOn: .constant(false))
        }
    }
}

#Preview {
    NavigationStack {
        AccessibilityView()
    }
}
