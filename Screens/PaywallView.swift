//
//  PaywallView.swift
//  TapGuard
//

import SwiftUI

struct PaywallView: View {
    @EnvironmentObject private var model: AppModel
    @Environment(\.dismiss) private var dismiss

    @State private var selected: PaywallPlan = .yearly

    var body: some View {
        ScrollView {
            content
        }
    }

    // MARK: - Main Content

    private var content: some View {
        VStack(spacing: 16) {
            heroSection
            proCard
            planPickerCard
            ctaSection
            finePrint
        }
        .padding()
    }

    // MARK: - Sections

    private var heroSection: some View {
        TGCard {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.accentColor.opacity(0.12))
                    Image(systemName: "sparkles")
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundColor(.accentColor)
                }
                .frame(width: 72, height: 72)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Break autopilot.")
                        .font(.headline)
                    Text("A tiny pause before opening apps changes everything.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
        }
    }

    private var proCard: some View {
        TGCard {
            VStack(alignment: .leading, spacing: 10) {
                Text("TapGuard Pro")
                    .font(.title2.weight(.semibold))

                Text("Guard more apps. Break autopilot faster.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                VStack(alignment: .leading, spacing: 8) {
                    benefit("Unlimited guarded apps", icon: "infinity")
                    benefit("Smart Confirm rules", icon: "sparkles")
                    benefit("Custom prompts", icon: "text.bubble.fill")
                    benefit("No ads", icon: "nosign")
                }
                .padding(.top, 4)
            }
        }
    }

    private var planPickerCard: some View {
        TGCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Choose a plan")
                    .font(.headline)

                ForEach(PaywallPlan.allCases) { plan in
                    planRow(plan)
                }
            }
        }
    }

    private var ctaSection: some View {
        VStack(spacing: 12) {
            Button {
                model.isPro = true
                dismiss()
            } label: {
                Text("Unlock Pro")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)

            Button("Continue with Free") {
                dismiss()
            }
            .foregroundColor(.secondary)
        }
    }

    private var finePrint: some View {
        Text("Cancel anytime in Settings. Payment handled via Apple ID in the real release.")
            .font(.footnote)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.top, 4)
    }

    // MARK: - Helpers

    private func planRow(_ plan: PaywallPlan) -> some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                selected = plan
            }
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 8) {
                        Text(plan.title)
                            .font(.headline)
                        if let badge = plan.badge {
                            Text(badge)
                                .font(.caption.weight(.semibold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(.ultraThinMaterial, in: Capsule())
                        }
                    }

                    Text(plan.price)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: selected == plan ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(selected == plan ? .accentColor : .secondary)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(selected == plan ? Color.accentColor.opacity(0.12) : Color.secondary.opacity(0.08))
            )
        }
        .buttonStyle(.plain)
    }

    private func benefit(_ text: String, icon: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
            Spacer()
        }
        .foregroundColor(.primary)
    }
}
