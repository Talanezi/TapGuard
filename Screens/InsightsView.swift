//
//  InsightsView.swift
//  TapGuard
//
//  Created by Thamer Alanezi on 12/25/25.
//

import SwiftUI

struct InsightsView: View {
    @EnvironmentObject private var model: AppModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                TGCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your Momentum").font(.headline)

                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading) {
                                Text("Streak")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text("\(model.streakDays) days")
                                    .font(.largeTitle.weight(.bold))
                            }
                            Spacer()
                            ProgressRing(progress: min(Double(model.todaysSaves) / 10.0, 1.0), lineWidth: 12)
                                .frame(width: 64, height: 64)
                        }

                        Text("You’ve saved yourself from autopilot **\(model.stats.totalSaves)** times.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                TGCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Today").font(.headline)
                        HStack {
                            Text("Autopilot saves")
                            Spacer()
                            AnimatedNumber(value: model.todaysSaves)
                                .font(.title2.weight(.bold))
                        }

                        Divider().opacity(0.25)

                        Text("Make it 10 today for a full ring.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                TGCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Guarded Apps").font(.headline)
                        ForEach(model.guardedApps.prefix(6)) { app in
                            HStack {
                                Label(app.displayName, systemImage: app.systemIcon)
                                Spacer()
                                Text("\(app.opensPrevented)")
                                    .foregroundStyle(.secondary)
                            }
                            .font(.subheadline)
                        }
                        if model.guardedApps.isEmpty {
                            Text("Add apps to start tracking saves.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Insights")
    }
}
