//
//  TapGuardApp.swift
//  TapGuard
//
//  Created by Thamer Alanezi on 12/25/25.
//

import SwiftUI

@main
struct TapGuardApp: App {
    @StateObject private var model = AppModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(model)
                .tint(Theme.tint)
        }
    }
}
