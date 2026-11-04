//
//  AboutView.swift
//  Preferences
//
//  Settings > General > About
//  Layout follows the supplied iOS About screenshots.
//

import SwiftUI

struct AboutView: View {
    @AppStorage("DeviceName") private var deviceName = "iPhone"

    @State private var wifiAddress = generateRandomAddress()
    @State private var bluetoothAddress = generateRandomAddress()
    @State private var eidValue = ""

    private let path = "/System/Library/PreferenceBundles/AboutSettings.bundle"

    var body: some View {
        CustomList(title: "About") {
            // Device identity
            Section {
                SLink(
                    "Name",
                    status: deviceName,
                    destination: NameView()
                )

                SLink(
                    "iOS Version",
                    status: "26.5",
                    destination: ControllerBridgeView(
                        "/System/Library/PrivateFrameworks/Settings/GeneralSettingsUI.framework/GeneralSettingsUI",
                        controller: "PSGSoftwareVersionController",
                        title: "iOS Version"
                    )
                )

                LabeledContent("Model Name", value: "iPhone 13 Pro")
                    .textSelection(.enabled)

                LabeledContent("Model Number", value: "MLW43RU/A")
                    .textSelection(.enabled)

                LabeledContent("Serial Number", value: "PGY2WNJW2H")
                    .textSelection(.enabled)
            }

            // Coverage status; Parts & Service History intentionally omitted.
            Section {
                SLink(
                    "Coverage Expired",
                    destination: AppleCareWarrantyView()
                )
            }

            // Media and storage
            Section {
                LabeledContent("Songs", value: "0")
                LabeledContent("Videos", value: "20")
                LabeledContent("Photos", value: "156")
                LabeledContent("Applications", value: "43")
                LabeledContent("Capacity", value: "128 GB")
                LabeledContent("Available", value: "30.68 GB")
            }

            // Device connectivity and identifiers
            Section {
                LabeledContent("Wi-Fi Address", value: wifiAddress)
                    .textSelection(.enabled)

                LabeledContent("Bluetooth", value: bluetoothAddress)
                    .textSelection(.enabled)

                LabeledContent("Modem Firmware", value: "5.51.03")
                    .textSelection(.enabled)

                NavigationLink("SEID", destination: SEIDView())

                VStack(alignment: .leading, spacing: 6) {
                    Text("EID")
                        .foregroundStyle(.primary)
                    Text(eidValue)
                        .foregroundStyle(.secondary)
                        .font(.body)
                        .textSelection(.enabled)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                LabeledContent("Network Provider Lock", value: "No SIM restrictions")
                    .textSelection(.enabled)
            }

            // Physical SIM
            Section {
                LabeledContent("Network", value: "Beeline")
                LabeledContent("Network Provider", value: "Beeline 70.0")
                LabeledContent("IMEI", value: "35 000000 000000 0")
                    .textSelection(.enabled)
                LabeledContent("ICCID", value: "8970000000000000000")
                    .textSelection(.enabled)
                LabeledContent("MEID", value: "35000000000000")
                    .textSelection(.enabled)
            } header: {
                Text("Physical SIM")
            }

            // Available SIM
            Section {
                LabeledContent("IMEI2", value: "35 000000 000000 0")
                    .textSelection(.enabled)
            } header: {
                Text("Available SIM")
            }

            // Certificate trust settings
            Section {
                NavigationLink("Certificate Trust Settings") {
                    ControllerBridgeView(
                        "/System/Library/PrivateFrameworks/Settings/GeneralSettingsUI.framework/GeneralSettingsUI",
                        controller: "PSGCertTrustSettings",
                        title: "Certificate Trust Settings"
                    )
                }
            }
        }
        .task {
            if eidValue.isEmpty {
                eidValue = makeRandomEID()
            }
        }
    }

    private func makeRandomEID() -> String {
        let digits = "0123456789"
        return String((0..<32).compactMap { _ in digits.randomElement() })
    }
}

private func generateRandomAddress() -> String {
    (0..<6)
        .map { _ in String(format: "%02X", Int.random(in: 0...255)) }
        .joined(separator: ":")
}

#Preview {
    NavigationStack {
        AboutView()
    }
}
