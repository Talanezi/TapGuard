//
//  SettingsView.swift
//  TapGuard
//
//  Created by Thamer Alanezi on 12/25/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var model: AppModel
    @State private var showPaywall = false

    var body: some View {
        Form {
            Section(header: Text("Experience")) {
                Toggle("Haptics", isOn: $model.settings.hapticsEnabled)
                Toggle("Animations", isOn: $model.settings.animationsEnabled)
                Toggle("Show tips", isOn: $model.settings.showTips)
            }

            Section(header: Text("Guard")) {
                Toggle("TapGuard Enabled", isOn: $model.settings.guardEnabled)

                HStack {
                    Text("Mode")
                    Spacer()
                    Text(model.settings.confirmMode.title)
                        .foregroundStyle(.secondary)
                }

                NavigationLink("Edit Rules") {
                    GuardRulesView()
                }
            }

            Section(header: Text("TapGuard Pro")) {
                HStack {
                    Text("Status")
                    Spacer()
                    Text(model.isPro ? "Pro" : "Free")
                        .foregroundStyle(model.isPro ? AnyShapeStyle(.tint) : AnyShapeStyle(.secondary))
                }

                if !model.isPro {
                    Button {
                        showPaywall = true
                    } label: {
                        Label("Upgrade to Pro", systemImage: "sparkles")
                    }
                }
            }

            Section(header: Text("About")) {
                LabeledContent("Version", value: "0.1 (Prototype)")
                LabeledContent("Privacy", value: "On-device")
            }

            // Debug: makes testing easier while you build
            Section(header: Text("Debug")) {
                Toggle("Unlock Pro (Debug)", isOn: $model.isPro)
                Button(role: .destructive) {
                    model.guardedApps = []
                    model.stats = UsageStats()
                } label: {
                    Text("Reset App Data")
                }
            }
        }
        .navigationTitle("Settings")
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }
}
