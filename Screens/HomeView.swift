//
//  HomeView.swift
//  TapGuard
//
//  Created by Thamer Alanezi on 12/25/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var model: AppModel

    @State private var showPicker = false
    @State private var showPaywall = false
    @State private var interceptApp: GuardedApp? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                header

                TGCard {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("TapGuard")
                                .font(.title2.weight(.semibold))
                            Spacer()
                            Toggle("", isOn: $model.settings.guardEnabled)
                                .labelsHidden()
                        }

                        Text(model.settings.guardEnabled
                             ? "Guard is active. Your chosen apps will ask before opening."
                             : "Guard is paused. Apps will open normally.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                        HStack(spacing: 12) {
                            statTile(title: "Today", value: model.todaysSaves, subtitle: "autopilot saves")
                            statTile(title: "Total", value: model.stats.totalSaves, subtitle: "all-time saves")
                            statTile(title: "Streak", value: model.streakDays, subtitle: "days")
                        }
                    }
                }

                TGCard {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Quick Actions").font(.headline)
                            Spacer()
                            if model.isPro { Pill(text: "PRO") }
                        }

                        PrimaryButton(title: "Choose Guarded Apps", systemImage: "plus.circle.fill") {
                            Haptics.tap(model.settings.hapticsEnabled)
                            showPicker = true
                        }

                        PrimaryButton(title: "Try Demo Intercept", systemImage: "hand.tap.fill") {
                            Haptics.tap(model.settings.hapticsEnabled)
                            // Demo: pick Instagram if guarded, otherwise first guarded app
                            let candidate = model.guardedApps.first(where: { $0.displayName == "Instagram" }) ?? model.guardedApps.first
                            interceptApp = candidate
                        }

                        if model.settings.showTips {
                            Text("Tip: Start with 1–2 apps you open without thinking. The goal is a tiny pause.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .transition(.opacity)
                        }
                    }
                }

                TGCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Rules").font(.headline)
                        Text(model.settings.confirmMode.title)
                            .font(.title3.weight(.semibold))
                        Text(model.settings.confirmMode.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        NavigationLink {
                            GuardRulesView()
                        } label: {
                            Label("Edit Guard Rules", systemImage: "slider.horizontal.3")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Home")
        .sheet(isPresented: $showPicker) {
            AppPickerView(showPaywall: $showPaywall)
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
        .sheet(item: $interceptApp) { app in
            InterceptView(app: app)
                .presentationDetents([.fraction(0.45)])
                .presentationDragIndicator(.visible)
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            // Optional logo image placeholder
            if let ui = UIImage(named: "TGLogo") {
                Image(uiImage: ui)
                    .resizable().scaledToFit()
                    .frame(width: 34, height: 34)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            } else {
                Image(systemName: "shield.lefthalf.filled")
                    .font(.system(size: 28, weight: .semibold))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Break autopilot.")
                    .font(.headline)
                Text("Small pause. Better day.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()

            ProgressRing(progress: min(Double(model.todaysSaves) / 10.0, 1.0), lineWidth: 10)
                .frame(width: 46, height: 46)
        }
        .padding(.horizontal, 2)
    }

    private func statTile(title: String, value: Int, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            AnimatedNumber(value: value)
                .font(.title2.weight(.bold))
            Text(subtitle).font(.caption2).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
