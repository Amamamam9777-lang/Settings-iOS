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
        .overlay(alignment: .bottomTrailing) {
            AssistiveTouchVisualButton()
                .padding(.trailing, 22)
                .padding(.bottom, 100)
                .allowsHitTesting(false)
                .accessibilityHidden(true)
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

private struct AssistiveTouchVisualButton: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.black.opacity(0.32))
                .overlay {
                    Circle().stroke(.white.opacity(0.8), lineWidth: 1.5)
                }

            Circle()
                .fill(.white.opacity(0.9))
                .frame(width: 31, height: 31)
                .overlay {
                    Circle().stroke(.black.opacity(0.28), lineWidth: 1)
                }

            Circle()
                .stroke(.black.opacity(0.35), lineWidth: 1)
                .frame(width: 43, height: 43)
        }
        .frame(width: 58, height: 58)
        .shadow(color: .black.opacity(0.22), radius: 5, y: 2)
    }
}

#Preview {
    ContentView()
        .environment(PrimarySettingsListModel())
}
