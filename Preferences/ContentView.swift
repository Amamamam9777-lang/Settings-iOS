//
//  ContentView.swift
//  Preferences
//
//  Settings
//

import SwiftUI
import UIKit

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
    @State private var assistiveTouchEnabled = UIAccessibility.isAssistiveTouchRunning
    @State private var assistiveTouchOffset: CGSize = .zero
    @State private var assistiveTouchDragOrigin: CGSize = .zero
    
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
        .overlay(alignment: .bottomTrailing) {
            if assistiveTouchEnabled {
                AssistiveTouchFloatingButton()
                    .offset(assistiveTouchOffset)
                    .padding(.trailing, 18)
                    .padding(.bottom, 96)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                assistiveTouchOffset = CGSize(
                                    width: assistiveTouchDragOrigin.width + value.translation.width,
                                    height: assistiveTouchDragOrigin.height + value.translation.height
                                )
                            }
                            .onEnded { _ in
                                assistiveTouchDragOrigin = assistiveTouchOffset
                            }
                    )
                    .transition(.opacity)
                    .zIndex(1000)
            }
        }
        .onAppear {
            assistiveTouchEnabled = UIAccessibility.isAssistiveTouchRunning
        }
        .onReceive(NotificationCenter.default.publisher(for: UIAccessibility.assistiveTouchStatusDidChangeNotification)) { _ in
            withAnimation(.easeInOut(duration: 0.2)) {
                assistiveTouchEnabled = UIAccessibility.isAssistiveTouchRunning
            }
        }
    }
}

private struct AssistiveTouchFloatingButton: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.black.opacity(0.48))
                .overlay {
                    Circle().stroke(Color.white.opacity(0.42), lineWidth: 2)
                }
            Circle()
                .fill(Color.white.opacity(0.96))
                .frame(width: 25, height: 25)
                .overlay {
                    Circle().stroke(Color.gray.opacity(0.65), lineWidth: 4)
                }
                .padding(7)
        }
        .frame(width: 54, height: 54)
        .shadow(color: .black.opacity(0.28), radius: 5, y: 2)
        .contentShape(Circle())
        .accessibilityLabel("AssistiveTouch")
    }
}

#Preview {
    ContentView()
        .environment(PrimarySettingsListModel())
}
