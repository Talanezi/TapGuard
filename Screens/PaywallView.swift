//
//  PaywallView.swift
//  TapGuard
//
//  Created by Thamer Alanezi on 12/25/25.
//

import SwiftUI

struct PaywallView: View {
    @EnvironmentObject private var model: AppModel
    @Environment(\.dismiss) private var dismiss

    @State private var selected: PaywallPlan = .yearly

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                hero

                TGCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("TapGuard Pro").font(.title2.weight(.semibold))
                        Text("Guard more apps. Break autopilot faster.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        VStack(alignment: .leading, spacing: 8) {
                            benefit("Unlimited guarded apps", icon: "infinity")
                            benefit("Smart Confirm rules", icon: "sparkles")
                            benefit("Custom prompts", icon: "text.bubble.fill")
                            benefit("No ads", icon: "nosign")
                        }
                        .padding(.top, 4)
                    }
                }

                TGCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Choose a plan").font(.headline)

                        ForEach(PaywallPlan.allCases) { plan in
                            Button {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                    selected = plan
                                }
                                Haptics.tap(model.settings.hapticsEnabled)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        HStack(spacing: 8) {
                                            Text(plan.title).font(.headline)
                                            if let badge = plan.badge {
                                                Pill(text: badge)
                                            }
                                        }
                                        Text(plan.price).foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: selected == plan ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(selected == plan ? .tint : .secondary)
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(selected == plan ? .tint.opacity(0.10) : .primary.opacity(0.04))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(selected == plan ? .tint.opacity(0.35) : .primary.opacity(0.08))
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                PrimaryButton(title: "Unlock Pro", systemImage: "sparkles") {
                    // Prototype purchase
                    model.isPro = true
                    Haptics.success(model.settings.hapticsEnabled)
                    dismiss()
                }

                Button("Continue with Free") { dismiss() }
                    .foregroundStyle(.secondary)

                Text("Cancel anytime in Settings. Payment is handled via Apple ID in the real release.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
            }
            .padding()
        }
    }

    private var hero: some View {
        TGCard {
            HStack(spacing: 14) {
                if let ui = UIImage(named: "PaywallHero") {
                    Image(uiImage: ui)
                        .resizable().scaledToFill()
                        .frame(width: 72, height: 72)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(.tint.opacity(0.12))
                        Image(systemName: "sparkles")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundStyle(.tint)
                    }
                    .frame(width: 72, height: 72)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Break autopilot.")
                        .font(.headline)
                    Text("A tiny pause before opening apps changes everything.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
        }
    }

    private func benefit(_ text: String, icon: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon).frame(width: 24)
            Text(text).font(.subheadline)
            Spacer()
        }
        .foregroundStyle(.primary)
    }
}
