//
//  GuardedAppsView.swift
//  TapGuard
//
//  Created by Thamer Alanezi on 12/25/25.
//

import SwiftUI

struct GuardedAppsView: View {
    @EnvironmentObject private var model: AppModel
    @State private var showPicker = false
    @State private var showPaywall = false

    var body: some View {
        List {
            Section {
                Toggle("TapGuard Enabled", isOn: $model.settings.guardEnabled)
            }

            Section(header: Text("Guarded Apps")) {
                if model.guardedApps.isEmpty {
                    ContentUnavailableView("No guarded apps", systemImage: "app.dashed", description: Text("Add apps you tend to open on autopilot."))
                } else {
                    ForEach(model.guardedApps) { app in
                        HStack(spacing: 12) {
                            appIcon(app)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(app.displayName).font(.headline)
                                Text(app.category).font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("\(app.opensPrevented)")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete { idx in
                        model.guardedApps.remove(atOffsets: idx)
                        Haptics.tap(model.settings.hapticsEnabled)
                    }
                }
            }

            Section {
                Button {
                    Haptics.tap(model.settings.hapticsEnabled)
                    showPicker = true
                } label: {
                    Label("Add / Remove Apps", systemImage: "plus.circle.fill")
                }
            }
        }
        .navigationTitle("Apps")
        .sheet(isPresented: $showPicker) {
            AppPickerView(showPaywall: $showPaywall)
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }

    private func appIcon(_ app: GuardedApp) -> some View {
        Group {
            if let name = app.iconAssetName, UIImage(named: name) != nil {
                Image(name).resizable().scaledToFit()
            } else {
                Image(systemName: app.systemIcon)
                    .font(.system(size: 18, weight: .semibold))
            }
        }
        .frame(width: 34, height: 34)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
