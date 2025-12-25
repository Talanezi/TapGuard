//
//  RootView.swift
//  TapGuard
//
//  Created by Thamer Alanezi on 12/25/25.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            NavigationStack { HomeView() }
                .tabItem { Label("Home", systemImage: "house.fill") }

            NavigationStack { GuardedAppsView() }
                .tabItem { Label("Apps", systemImage: "app.badge.checkmark") }

            NavigationStack { InsightsView() }
                .tabItem { Label("Insights", systemImage: "chart.line.uptrend.xyaxis") }

            NavigationStack { SettingsView() }
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
    }
}
