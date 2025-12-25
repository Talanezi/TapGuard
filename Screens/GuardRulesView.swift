//
//  GuardRulesView.swift
//  TapGuard
//
//  Created by Thamer Alanezi on 12/25/25.
//

import SwiftUI

struct GuardRulesView: View {
    @EnvironmentObject private var model: AppModel

    var body: some View {
        Form {
            Section(header: Text("Confirm Mode")) {
                Picker("Mode", selection: $model.settings.confirmMode) {
                    ForEach(ConfirmMode.allCases) { mode in
                        VStack(alignment: .leading) {
                            Text(mode.title)
                            Text(mode.subtitle).font(.caption).foregroundStyle(.secondary)
                        }
                        .tag(mode)
                    }
                }
                .pickerStyle(.inline)
            }

            Section(header: Text("Smart Confirm")) {
                HStack {
                    Text("Recent window")
                    Spacer()
                    Text("\(model.settings.smartWindowMinutes) min").foregroundStyle(.secondary)
                }

                Slider(value: Binding(
                    get: { Double(model.settings.smartWindowMinutes) },
                    set: { model.settings.smartWindowMinutes = Int($0.rounded()) }
                ), in: 5...60, step: 5)
                .disabled(model.settings.confirmMode != .smartRecent)
            }

            Section(footer: Text("In the real version, Smart Confirm would only show the prompt if you opened the app within this window.")) {
                EmptyView()
            }
        }
        .navigationTitle("Guard Rules")
    }
}
