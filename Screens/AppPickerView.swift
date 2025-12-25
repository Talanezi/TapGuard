//
//  AppPickerView.swift
//  TapGuard
//
//  Created by Thamer Alanezi on 12/25/25.
//

import SwiftUI

struct AppPickerView: View {
    @EnvironmentObject private var model: AppModel
    @Environment(\.dismiss) private var dismiss

    @Binding var showPaywall: Bool
    @State private var search = ""

    var filtered: [GuardedApp] {
        if search.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return model.catalog }
        return model.catalog.filter { $0.displayName.localizedCaseInsensitiveContains(search) || $0.category.localizedCaseInsensitiveContains(search) }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Search apps…", text: $search)
                }

                Section(header: Text("Apps")) {
                    ForEach(filtered) { app in
                        Button {
                            Haptics.tap(model.settings.hapticsEnabled)
                            if model.guardedApps.contains(app) {
                                model.toggleGuard(for: app)
                            } else {
                                if model.canAddMoreApps() {
                                    model.toggleGuard(for: app)
                                } else {
                                    // hit free limit
                                    showPaywall = true
                                }
                            }
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: app.systemIcon)
                                    .frame(width: 30, height: 30)
                                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(app.displayName).font(.headline)
                                    Text(app.category).font(.caption).foregroundStyle(.secondary)
                                }

                                Spacer()

                                if model.guardedApps.contains(app) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.tint)
                                        .symbolEffectIfAvailable()
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }

                if !model.isPro {
                    Section {
                        TGCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Free limit").font(.headline)
                                Text("You can guard up to \(model.settings.freeAppLimit) apps on the free version.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)

                                PrimaryButton(title: "Unlock Pro", systemImage: "sparkles") {
                                    showPaywall = true
                                }
                            }
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                    }
                }
            }
            .navigationTitle("Choose Apps")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// Small helper: use iOS 17 symbol effects when available
private extension View {
    @ViewBuilder func symbolEffectIfAvailable() -> some View {
        if #available(iOS 17.0, *) {
            self.symbolEffect(.bounce, value: UUID())
        } else {
            self
        }
    }
}
