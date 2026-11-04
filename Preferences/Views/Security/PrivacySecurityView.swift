//
//  PrivacySecurityView.swift
//  Preferences
//
//  Settings > Privacy & Security
//

import SwiftUI
import UIKit

struct PrivacySecurityView: View {
    @State private var titleVisible = false
    @State private var showingHelpSheet = false
    let communication = "/System/Library/PrivateFrameworks/CommunicationSafetySettingsUI.framework"
    let safety = "/System/Library/PreferenceBundles/DigitalSeparationSettings.bundle"
    let privacy = "/System/Library/PreferenceBundles/PrivacyAndSecuritySettings.bundle"
    
    var body: some View {
        CustomList(title: titleVisible ? "Privacy & Security".localized(path: privacy) : "") {
            // MARK: Placard
            Placard(
                title: "Privacy & Security".localized(path: privacy),
                icon: "com.apple.graphic-icon.privacy",
                description: "Placard Subtitle".localized(path: privacy).replacing("helpkit", with: "pref"),
                isVisible: $titleVisible
            )
            
            // MARK: Location Services, Tracking Section
            Section {
                SLink(
                    "Location Services".localized(path: privacy),
                    icon: "com.apple.graphic-icon.location",
                    subtitle: "None".localized(path: privacy),
                    destination: LocationServicesView()
                )
                SLink(
                    "Tracking".localized(path: privacy),
                    icon: "com.apple.graphic-icon.app-tracking-transparency",
                    status: "0",
                    destination: TrackingView()
                )
            }
            
            // MARK: App Permissions
            Section {
                SLink(
                    "Calendars".localized(path: privacy),
                    icon: "com.apple.mobilecal",
                    subtitle: "None".localized(path: privacy),
                    destination: ControllerBridgeView(
                        "/System/Library/PrivateFrameworks/Settings/PrivacySettingsUI.framework/PrivacySettingsUI",
                        controller: "PUICalendarPrivacyController",
                        title: "Calendars".localized(path: privacy)
                    )
                )
                SLink(
                    "Contacts".localized(path: privacy),
                    icon: "com.apple.MobileAddressBook",
                    subtitle: "None".localized(path: privacy),
                    destination: ControllerBridgeView(
                        "/System/Library/PrivateFrameworks/Settings/PrivacySettingsUI.framework/PrivacySettingsUI",
                        controller: "PUIContactsPrivacyController",
                        title: "Contacts".localized(path: privacy)
                    )
                )
                SLink(
                    "Files & Folders".localized(path: privacy),
                    icon: "com.apple.DocumentsApp",
                    subtitle: "None".localized(path: privacy),
                    destination: ControllerBridgeView(
                        "/System/Library/PrivateFrameworks/Settings/PrivacySettingsUI.framework/PrivacySettingsUI",
                        controller: "PUIFileAccessController",
                        title: "Files & Folders".localized(path: privacy)
                    )
                )
                SLink(
                    "Focus".localized(path: privacy),
                    icon: "com.apple.graphic-icon.focus",
                    subtitle: "None".localized(path: privacy),
                    destination: AppPermissionsView(permission: "FOCUS")
                )
                SLink(
                    "Health".localized(path: privacy),
                    icon: "com.apple.Health",
                    subtitle: "None".localized(path: privacy),
                    destination: ControllerBridgeView(
                        "/System/Library/PreferenceBundles/Privacy/HealthPrivacySettings.bundle/HealthPrivacySettings",
                        controller: "HKHealthPrivacySettingsSourcesViewController",
                        title: "Health".localized(path: privacy)
                    )
                )
                SLink(
                    "Home Accessories".localized(path: privacy),
                    icon: "com.apple.Home.HomeControlService",
                    subtitle: "None".localized(path: privacy),
                    destination: AppPermissionsView(permission: "WILLOW")
                )
                SLink(
                    "Media & Apple Music".localized(path: privacy),
                    icon: "com.apple.Music",
                    subtitle: "None".localized(path: privacy),
                    destination: AppPermissionsView(permission: "MEDIALIBRARY")
                )
                SLink(
                    "Passkeys Access for Web Browsers".localized(path: privacy),
                    icon: "com.apple.graphic-icon.person-passkey",
                    subtitle: "None".localized(path: privacy),
                    destination: AppPermissionsView(permission: "PASSKEYS")
                )
                SLink(
                    "Photos".localized(path: privacy),
                    icon: "com.apple.mobileslideshow",
                    subtitle: "None".localized(path: privacy),
                    destination: ControllerBridgeView(
                        "/System/Library/PrivateFrameworks/Settings/PrivacySettingsUI.framework/PrivacySettingsUI",
                        controller: "PUIPhotosPrivacyController",
                        title: "Photos".localized(path: privacy)
                    )
                )
                SLink(
                    "Reminders".localized(path: privacy),
                    icon: "com.apple.reminders",
                    subtitle: "None".localized(path: privacy),
                    destination: AppPermissionsView(permission: "REMINDERS")
                )
                if UIDevice.iPhone {
                    SLink(
                        "Wallet".localized(path: privacy),
                        icon: "com.apple.Passbook",
                        subtitle: "None".localized(path: privacy),
                        destination: AppPermissionsView(permission: "WALLET")
                    )
                }
            }
            
            // MARK: Sensor Permissions
            Section {
                if !UIDevice.IsSimulator {
                    SLink(
                        "Accessories".localized(path: privacy),
                        icon: "com.apple.graphic-icon.accessories",
                        status: "0",
                        destination: ControllerBridgeView(
                            "/System/Library/PrivateFrameworks/Settings/PrivacySettingsUI.framework/PrivacySettingsUI",
                            controller: "PUIAccessoriesController",
                            title: "Accessories".localized(path: privacy)
                        )
                    )
                }
                SLink(
                    "Bluetooth".localized(path: privacy),
                    icon: "com.apple.graphic-icon.bluetooth",
                    status: "0",
                    destination: AppPermissionsView(permission: "BT_PERIPHERAL")
                )
                SLink(
                    "Camera".localized(path: privacy),
                    icon: "com.apple.graphic-icon.camera",
                    status: "0",
                    destination: AppPermissionsView(permission: "CAMERA")
                )
                SLink(
                    "Critical Messages".localized(path: privacy),
                    icon: "com.apple.graphic-icon.critical-messages",
                    status: "0",
                    destination: ControllerBridgeView(
                        "/System/Library/PrivateFrameworks/MessagesSettingsUI.framework/MessagesSettingsUI",
                        controller: "CKSettingsCriticalMessagesViewController",
                        title: "Critical Messages".localized(path: privacy)
                    )
                )
                SLink(
                    "Local Network".localized(path: privacy),
                    icon: "com.apple.graphic-icon.local-network",
                    status: "0",
                    destination: ControllerBridgeView(
                        "/System/Library/PrivateFrameworks/Settings/PrivacySettingsUI.framework/PrivacySettingsUI",
                        controller: "PUINetworkController",
                        title: "Local Network".localized(path: privacy)
                    )
                )
                SLink(
                    "Microphone".localized(path: privacy),
                    icon: "com.apple.graphic-icon.microphone-access",
                    status: "0",
                    destination: AppPermissionsView(permission: "MICROPHONE")
                )
                SLink(
                    "Motion".localized(path: privacy),
                    icon: "com.apple.graphic-icon.motion-and-fitness",
                    status: "0",
                    destination: AppPermissionsView(permission: "MOTION")
                )
                SLink(
                    "Nearby Interactions".localized(path: privacy),
                    icon: "com.apple.graphic-icon.nearby-interactions",
                    status: "0",
                    destination: AppPermissionsView(permission: "NEARBY_INTERACTIONS")
                )
                if UIDevice.iPhone {
                    SLink(
                        "Research Sensor & Usage Data".localized(path: privacy),
                        icon: "com.apple.graphic-icon.research-sensor-and-usage-data",
                        status: "0",
                        destination: ControllerBridgeView(
                            "/System/Library/PreferenceBundles/Privacy/SensorKitPrivacySettings.bundle/SensorKitPrivacySettings",
                            controller: "SensorKitPrivacySettingsController",
                            title: "Research Sensor & Usage Data".localized(path: privacy)
                        )
                    )
                    SLink(
                        "Speech Recognition".localized(path: privacy),
                        icon: "com.apple.graphic-icon.waveform",
                        status: "0",
                        destination: AppPermissionsView(permission: "SPEECH_RECOGNITION")
                    )
                }
            }
            
            // MARK: Journaling Suggestions
            if UIDevice.iPhone && !UIDevice.IsSimulator {
                Section {
                    SLink(
                        "Journaling Suggestions".localized(path: privacy),
                        icon: "com.apple.graphic-icon.journaling-suggestions",
                        destination: JournalingSuggestionsView()
                    )
                }
            }
            
            // MARK: Safety Check
            
            Section {
                SLink(
                    "Blocked contacts".localized(path: privacy),
                    icon: "com.apple.graphic-icon.content-and-privacy-restrictions",
                    destination: EmptyView()
                )
                if UIDevice.iPhone {
                    SLink(
                        "SAFETY_CHECK".localized(path: safety),
                        icon: "com.apple.graphic-icon.safety-check",
                        destination: SafetyCheckView()
                    )
                }
            } footer: {
                if UIDevice.iPhone {
                    Text("Protect your personal safety by staying aware of which people, apps, and devices have access to your information.".localized(path: privacy))
                }
            }
            
            // MARK: Sensitive Content Warning
            Section {
                SLink(
                    "Sensitive Content Warning".localized(path: privacy),
                    icon: "com.apple.graphic-icon.sensitive-media-check",
                    status: "Off".localized(path: privacy),
                    destination: ControllerBridgeView(
                        "CommunicationSafetySettings",
                        controller: "CommunicationSafetySettings",
                        title: "Sensitive Content Warning".localized(path: privacy)
                    )
                )
            } footer: {
                Text(.init("Detect nude photos and videos before they are viewed on your Device, and receive guidance to help make a safe choice. Apple does not have access to the photos or videos. [Learn more…](%@)".localized(path: communication, "https://support.apple.com/105071")))
            }
            
            // MARK: Analytics & Improvements, Advertising
            Section {
                SLink(
                    "Analytics & Improvements".localized(path: privacy),
                    icon: "com.apple.graphic-icon.analytics-and-improvements",
                    destination: AnalyticsImprovementsView()
                )
                SLink(
                    "Apple Advertising".localized(path: privacy),
                    icon: "com.apple.graphic-icon.apple-advertising",
                    destination: AppleAdvertisingView()
                )
            }
            
            if !UIDevice.IsSimulator {
                // MARK: Transparency Logs
                Section {
                    SLink(
                        "App Privacy Report".localized(path: privacy),
                        icon: "com.apple.graphic-icon.app-privacy-report",
                        status: "Off".localized(path: privacy),
                        destination: ControllerBridgeView(
                            "/System/Library/PrivateFrameworks/Settings/PrivacySettingsUI.framework/PrivacySettingsUI",
                            controller: "PUIReportController",
                            title: "App Privacy Report".localized(path: privacy)
                        )
                    )
                    if UIDevice.IntelligenceCapability {
                        SLink(
                            "Apple Intelligence Report".localized(path: privacy),
                            icon: "com.apple.application-icon.apple-intelligence",
                            status: "Off".localized(path: privacy)
                        ) {}
                    }
                } header: {
                    Text("Transparency Logs".localized(path: privacy))
                }

                // MARK: Security
                Section {
                    SLink(
                        "Wired Accessories".localized(path: privacy),
                        icon: "com.apple.graphic-icon.usb-c-port",
                        status: "Automatically Allow When Unlocked"
                    ) {}
                    SLink(
                        "Background Security Improvements".localized(path: privacy),
                        icon: "com.apple.graphic-icon.background-security-improvements"
                    ) {}
                    if UIDevice.iPhone {
                        SLink(
                            "Stolen Device Protection".localized(path: privacy),
                            icon: "com.apple.graphic-icon.stolen-device-protection",
                            status: "Off".localized(path: privacy)
                        ) {}
                    }
                    SLink(
                        "Lockdown Mode".localized(path: privacy),
                        icon: "com.apple.graphic-icon.privacy",
                        status: "Off".localized(path: privacy),
                        destination: ControllerBridgeView(
                            "/System/Library/PrivateFrameworks/Settings/PrivacySettingsUI.framework/PrivacySettingsUI",
                            controller: "PUILockdownModeController",
                            title: "Lockdown Mode".localized(path: privacy)
                        )
                    )
                } header: {
                    Text("Security".localized(path: privacy))
                }
            }
        }
        .onOpenURL { url in
            if url.scheme == "pref" {
                showingHelpSheet.toggle()
            }
        }
        .sheet(isPresented: $showingHelpSheet) {
            HLPHelpViewController(topicID: UIDevice.iPhone ? "iph6e7d349d1" : "ipad9ae59af9")
                .ignoresSafeArea()
        }
    }
}

#Preview {
    NavigationStack {
        PrivacySecurityView()
    }
}


// MARK: - Local Analytics & Improvements demo screens
// The attached diagnostic reports are bundled in this Swift file. They are displayed locally
// and are not uploaded or sent to any service.

struct AnalyticsImprovementsView: View {
    @AppStorage("ShareiPhoneAnalytics") private var shareiPhoneAnalytics = false
    @AppStorage("ShareiCloudAnalytics") private var shareiCloudAnalytics = false
    @AppStorage("ImproveSiriAndDictation") private var improveSiriAndDictation = false
    @AppStorage("ImproveAssistiveVoiceFeatures") private var improveAssistiveVoiceFeatures = false

    var body: some View {
        CustomList(title: "Analytics & Improvements") {
            Section {
                Toggle("Share iPhone Analytics", isOn: $shareiPhoneAnalytics)

                NavigationLink {
                    AnalyticsDataView()
                } label: {
                    Text("Analytics Data")
                }
            } footer: {
                Text("Help Apple improve its products and services by automatically sending daily diagnostic and usage information. Data may include location.")
            }

            Section {
                Toggle("Share iCloud Analytics", isOn: $shareiCloudAnalytics)
            } footer: {
                Text("Help Apple improve its products and services by sharing analytics from your iCloud account.")
            }

            Section {
                Toggle("Improve Siri & Dictation", isOn: $improveSiriAndDictation)
            } footer: {
                Text("Help Apple improve Siri and Dictation by sharing the audio recordings and transcripts of your interactions with Siri, Dictation and Translate.")
            }

            Section {
                Toggle("Improve Assistive Voice Features", isOn: $improveAssistiveVoiceFeatures)
            } footer: {
                Text("Help Apple improve accessibility features by sharing diagnostic and usage information.")
            }
        }
    }
}

// MARK: - Analytics Data

private struct AnalyticsLogFile: Identifiable, Hashable {
    let url: URL

    var id: String { url.lastPathComponent }
    var fileName: String { url.lastPathComponent }
}

private enum AnalyticsLogStore {
    static func load() -> [AnalyticsLogFile] {
        guard let resourcesURL = Bundle.main.resourceURL else { return [] }

        let folderURL = resourcesURL.appendingPathComponent("AnalyticsLogs", isDirectory: true)
        guard let fileURLs = try? FileManager.default.contentsOfDirectory(
            at: folderURL,
            includingPropertiesForKeys: [.contentModificationDateKey],
            options: [.skipsHiddenFiles]
        ) else {
            return []
        }

        return fileURLs
            .filter { $0.pathExtension.lowercased() == "ips" }
            .map(AnalyticsLogFile.init(url:))
            .sorted {
                $0.fileName.localizedStandardCompare($1.fileName) == .orderedDescending
            }
    }
}

struct AnalyticsDataView: View {
    @State private var logs = AnalyticsLogStore.load()
    @State private var searchText = ""
    @FocusState private var searchIsFocused: Bool

    private var filteredLogs: [AnalyticsLogFile] {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return logs
        }
        return logs.filter {
            $0.fileName.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    logCard
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                }
                .frame(maxWidth: .infinity, alignment: .top)
                .padding(.bottom, 18)
            }
            .scrollIndicators(.hidden)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            searchBar
        }
        .navigationTitle("Analytics Data")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .onAppear {
            // Reload when returning to this screen so newly added .ips files appear.
            logs = AnalyticsLogStore.load()
        }
    }

    private var logCard: some View {
        VStack(spacing: 0) {
            if filteredLogs.isEmpty {
                Text(searchText.isEmpty ? "No Analytics Data" : "No Results")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 58, alignment: .center)
            } else {
                ForEach(Array(filteredLogs.enumerated()), id: \.element.id) { item in
                    VStack(spacing: 0) {
                        NavigationLink {
                            AnalyticsLogDetailView(log: item.element)
                        } label: {
                            HStack(spacing: 10) {
                                Text(item.element.fileName)
                                    .font(.system(size: 14.5, weight: .regular))
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                                    .fixedSize(horizontal: false, vertical: true)

                                Spacer(minLength: 2)

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundStyle(Color(uiColor: .tertiaryLabel))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
                            .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                        .buttonStyle(AnalyticsLogRowButtonStyle())

                        if item.offset < filteredLogs.count - 1 {
                            Rectangle()
                                .fill(Color.white.opacity(0.10))
                                .frame(height: 0.5)
                                .padding(.horizontal, 12)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private var searchBar: some View {
        HStack(spacing: 8) {
            HStack(spacing: 9) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color(uiColor: .secondaryLabel))

                TextField("Search", text: $searchText)
                    .font(.system(size: 15.5, weight: .regular))
                    .textFieldStyle(.plain)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.search)
                    .focused($searchIsFocused)

                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                        searchIsFocused = true
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 15))
                            .foregroundStyle(Color(uiColor: .tertiaryLabel))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Clear search text")
                }
            }
            .padding(.horizontal, 13)
            .frame(width: 208, height: 42)
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(Capsule())
            .overlay {
                Capsule().stroke(Color.white.opacity(0.07), lineWidth: 0.8)
            }

            Button {
                searchIsFocused = false
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 42, height: 42)
                    .background(Color(uiColor: .secondarySystemBackground), in: Circle())
                    .overlay {
                        Circle().stroke(Color.white.opacity(0.07), lineWidth: 0.8)
                    }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Dismiss search keyboard")
        }
        .frame(maxWidth: 260, alignment: .leading)
        .padding(.leading, 16)
        .padding(.top, 7)
        .padding(.bottom, 5)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black)
    }
}

private struct AnalyticsLogRowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .fill(configuration.isPressed ? Color.white.opacity(0.15) : Color.clear)
                    .padding(.horizontal, 4)
            }
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

private struct AnalyticsLogDetailView: View {
    let log: AnalyticsLogFile

    @State private var reportText = "Loading report…"
    @State private var showingShareSheet = false

    var body: some View {
        AnalyticsLogTextView(text: reportText)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle(log.fileName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingShareSheet = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .accessibilityLabel("Share report")
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                AnalyticsShareSheet(items: [log.url])
            }
            .task {
                loadReport()
            }
    }

    private func loadReport() {
        do {
            reportText = try String(contentsOf: log.url, encoding: .utf8)
        } catch {
            reportText = "Unable to open this report.\n\n\(error.localizedDescription)"
        }
    }
}

/// UITextView handles large .ips files much more reliably than a single huge SwiftUI Text view.
private struct AnalyticsLogTextView: UIViewRepresentable {
    let text: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.font = UIFont.monospacedSystemFont(ofSize: 10.5, weight: .regular)
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = true
        textView.alwaysBounceVertical = true
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 12, bottom: 18, right: 12)
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainer.widthTracksTextView = true
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.text = text
        return textView
    }

    func updateUIView(_ textView: UITextView, context: Context) {
        if textView.text != text {
            textView.text = text
        }
    }
}

private struct AnalyticsShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ controller: UIActivityViewController, context: Context) {}
}
