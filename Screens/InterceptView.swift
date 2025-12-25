//
//  InterceptView.swift
//  TapGuard
//
//  Created by Thamer Alanezi on 12/25/25.
//

import SwiftUI

struct InterceptView: View {
    @EnvironmentObject private var model: AppModel
    @Environment(\.dismiss) private var dismiss

    let app: GuardedApp

    @State private var pulse = false

    var body: some View {
        VStack(spacing: 14) {
            Spacer(minLength: 6)

            ZStack {
                Circle()
                    .fill(.tint.opacity(0.12))
                    .frame(width: 88, height: 88)
                    .scaleEffect(pulse ? 1.05 : 0.96)
                    .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: pulse)

                Image(systemName: app.systemIcon)
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(.tint)
            }
            .onAppear { pulse = true }

            Text("Open \(app.displayName)?")
                .font(.title3.weight(.semibold))

            Text(model.settings.confirmMode == .smartRecent
                 ? "You opened it recently. Quick autopilot check."
                 : "Quick autopilot check.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            HStack(spacing: 10) {
                Button {
                    Haptics.tap(model.settings.hapticsEnabled)
                    // Demo: user chooses "Open anyway" -> do nothing
                    dismiss()
                } label: {
                    Text("Open anyway")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)

                Button {
                    Haptics.success(model.settings.hapticsEnabled)
                    model.recordAutopilotSave(for: app)
                    dismiss()
                } label: {
                    Text("Not now")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding(.horizontal)

            Spacer(minLength: 4)

            if model.settings.showTips {
                Text("Choosing **Not now** counts as an autopilot save.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 8)
            }
        }
        .padding(.top, 10)
    }
}
