//
//  ContentView.swift
//  Preferences
//
//  Settings
//

import SwiftUI

struct ContentView: View {
    @AppStorage("FollowUpDismissed") private var followUpDismissed = false
    @AppStorage("ForceQueryError") private var forceQueryError = false
    @AppStorage("SettingsAssistiveTouchOverlayEnabled") private var assistiveTouchOverlayEnabled = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(PrimarySettingsListModel.self) private var model
    @State private var searchText = ""
    @State private var showingSignInError = false
    @State private var showingSignInSheet = false
    @State private var showingResearchSheet = false
    @State private var showingSupervisedSheet = false
    @State private var showingSearchQueryError = false
    
    var body: some View {
        @Bindable var model = model
        
        NavigationSplitView {
            List(selection: $model.selection) {
                if searchText.isEmpty {
                    if UIDevice.ResearchFuse {
                        Section {} footer: {
                            Text(.init(String(localized: "SECURITY_RESEARCH_DEVICE_FOOTER").replacing(
                                "securityResearchDevice://",
                                with: "pref://securityResearchDevice"))
                            )
                        }
                    }
                    
                    if UIDevice.isSupervised {
                        Section {} footer: {
                            Text(.init(String(localized: "Device Supervision Footer with Organization Name: %@").replacing(
                                "supervisedDevice://",
                                with: "pref://supervisedDevice"))
                            )
                        }
                    }
                    
                    Section {
                        NavigationLink {
                            AppleAccountView()
                        } label: {
                            AppleAccountSection()
                        }
                        .navigationLinkIndicatorVisibility(UIDevice.iPad && !model.isCompact ? .hidden : .visible)
                    }
                    
                    if !followUpDismissed {
                        SettingsGroup(model.followUpSettings)
                    }
                    
                    SettingsGroup(model.radioSettings)
                    SettingsGroup(model.mainSettings)
                    SettingsGroup(model.attentionSettings)
                    SettingsGroup(model.securitySettings)
                    SettingsGroup(model.serviceSettings)
                    SettingsGroup(model.appsSettings)
                }
            }
            .navigationTitle(UIDevice.iPhone || model.isCompact ? .settings : "")
            .toolbar(removing: .sidebarToggle)
            .alert(.connectToTheInternetToSignInToYourDevice, isPresented: $showingSignInError) {
                Button(.ok) {}
            }
            .sheet(isPresented: $showingSignInSheet) {
                NavigationStack {
                    SelectSignInOptionView()
                        .interactiveDismissDisabled()
                }
            }
            .searchable(
                text: $searchText,
                isPresented: $model.searchFocused,
                placement: UIDevice.iPad ? .navigationBarDrawer(displayMode: .always) : .automatic
            )
            .overlay {
                if UIDevice.iPad && model.searchFocused && !searchText.isEmpty {
                    GeometryReader { geo in
                        List {
                            if searchText.isEmpty {
                                Section("Suggestions") {}
                            } else {
                                ContentUnavailableView.search(text: searchText)
                                    .frame(minHeight: 0, idealHeight: geo.size.height, maxHeight: .infinity)
                                    .edgesIgnoringSafeArea(.all)
                                    .listRowSeparator(.hidden)
                            }
                        }
                        .scrollDisabled(!searchText.isEmpty)
                        .listStyle(.inset)
                    }
                } else if UIDevice.iPhone && model.searchFocused {
                    GeometryReader { geo in
                        List {
                            if searchText.isEmpty {
                                SettingsSearchView()
                            } else {
                                ContentUnavailableView.search(text: searchText)
                                    .frame(minHeight: 0, idealHeight: geo.size.height, maxHeight: .infinity)
                                    .edgesIgnoringSafeArea(.all)
                                    .listRowSeparator(.hidden)
                            }
                        }
                        .scrollDisabled(!searchText.isEmpty)
                        .listStyle(.inset)
                    }
                }
            }
        } detail: {
            NavigationStack(path: $model.path) {
                model.selection?.destination
            }
        }
        .accessibilityIdentifier("SettingsList")
        .overlay {
            if assistiveTouchOverlayEnabled {
                AssistiveTouchFloatingButton()
                    .zIndex(1000)
            }
        }
        .alert(
            .tapToRadar,
            isPresented: $showingSearchQueryError
        ) {
            Button(role: .cancel) {}
            Button(.fileRadar) {}
        } message: {
            Text("Settings encountered an error while querying search content. This can result in missing search items. Please file a Radar.")
        }
        .overlay {
            if UIDevice.`apple-internal-install` {
                VStack {
                    SettingsAppDebugMenuGestureProxyView {
                        model.showingDebugMenu.toggle()
                    }
                    .frame(height: UIDevice.iPad ? 50 : 75, alignment: .top)
                    Spacer()
                }
                .ignoresSafeArea()
            }
        }
        .onAppear {
            model.isCompact = horizontalSizeClass == .compact
            if model.selection == nil && UIDevice.iPad && !model.isCompact {
                model.selection = model.mainSettings.first
            }
        }
        .onChange(of: model.path) { oldValue, _ in
            if !oldValue.isEmpty {
                SettingsLogger.log("Last Navigation Event: \(oldValue.joined(separator: " → "))")
            }
        }
        .onChange(of: horizontalSizeClass) {
            model.isCompact = horizontalSizeClass == .compact
            if !model.isCompact && model.selection == nil {
                model.selection = model.mainSettings.first
            }
        }
        .onChange(of: searchText) {
            if !searchText.isEmpty && forceQueryError {
                showingSearchQueryError = true
                forceQueryError = false
            }
        }
        .onOpenURL { url in
            if url.absoluteString == "pref://securityResearchDevice" {
                showingResearchSheet = true
            } else if url.absoluteString == "pref://supervisedDevice" {
                showingSupervisedSheet = true
            }
        }
        .sheet(isPresented: $model.showingDebugMenu) {
            NavigationStack {
                DebugView()
            }
            .presentationDetents(UIDevice.iPhone ? [.medium, .large] : [.large])
        }
        .sheet(isPresented: $showingResearchSheet) {
            NavigationStack {
                OBWelcomeController(
                    title: String(localized: .aboutSecurityResearchDevice),
                    detailText: String(localized: .securityResearchText)
                )
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(.done) {
                            showingResearchSheet = false
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingSupervisedSheet) {
            DeviceSupervisionView()
        }
    }
}

/// Minimal in-app AssistiveTouch indicator. No menu or additional window is presented.
private struct AssistiveTouchFloatingButton: View {
    @AppStorage("SettingsAssistiveTouchButtonX") private var savedX = -1.0
    @AppStorage("SettingsAssistiveTouchButtonY") private var savedY = -1.0
    @State private var position: CGPoint?
    @State private var dragOrigin: CGPoint?

    private let diameter: CGFloat = 62

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let current = position ?? CGPoint(
                x: savedX > 0 ? min(max(CGFloat(savedX), diameter / 2), size.width - diameter / 2) : size.width - diameter / 2 - 8,
                y: savedY > 0 ? min(max(CGFloat(savedY), diameter / 2), size.height - diameter / 2) : size.height * 0.52
            )

            Circle()
                .fill(Color.black.opacity(0.48))
                .overlay { Circle().stroke(Color.white.opacity(0.48), lineWidth: 1.6) }
                .overlay { Circle().fill(Color.white).frame(width: 23, height: 23) }
                .frame(width: diameter, height: diameter)
                .shadow(color: .black.opacity(0.24), radius: 4, x: 0, y: 1)
                .contentShape(Circle())
                .position(current)
                .gesture(DragGesture(minimumDistance: 2)
                    .onChanged { value in
                        let origin = dragOrigin ?? current
                        dragOrigin = origin
                        position = CGPoint(
                            x: min(max(origin.x + value.translation.width, diameter / 2), size.width - diameter / 2),
                            y: min(max(origin.y + value.translation.height, diameter / 2), size.height - diameter / 2)
                        )
                    }
                    .onEnded { _ in
                        if let position {
                            savedX = Double(position.x)
                            savedY = Double(position.y)
                        }
                        dragOrigin = nil
                    })
                .accessibilityLabel("AssistiveTouch")
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
        .environment(PrimarySettingsListModel())
}
