//
//  AppModel.swift
//  TapGuard
//
//  Created by Thamer Alanezi on 12/25/25.
//

import Foundation
import SwiftUI

@MainActor
final class AppModel: ObservableObject {

    @Published var guardedApps: [GuardedApp] {
        didSet { Persistence.save(guardedApps, key: StorageKeys.guardedApps) }
    }

    @Published var settings: AppSettings {
        didSet { Persistence.save(settings, key: StorageKeys.settings) }
    }

    @Published var stats: UsageStats {
        didSet { Persistence.save(stats, key: StorageKeys.stats) }
    }

    @Published var isPro: Bool {
        didSet { UserDefaults.standard.set(isPro, forKey: StorageKeys.isPro) }
    }

    // A curated “starter list” so the picker looks real
    let catalog: [GuardedApp] = [
        .init(displayName: "Instagram", category: "Social", systemIcon: "camera"),
        .init(displayName: "TikTok", category: "Social", systemIcon: "play.rectangle.fill"),
        .init(displayName: "X", category: "Social", systemIcon: "xmark"),
        .init(displayName: "YouTube", category: "Video", systemIcon: "play.rectangle"),
        .init(displayName: "Safari", category: "Browser", systemIcon: "safari.fill"),
        .init(displayName: "Messages", category: "Communication", systemIcon: "message.fill"),
        .init(displayName: "Mail", category: "Communication", systemIcon: "envelope.fill"),
        .init(displayName: "Reddit", category: "Social", systemIcon: "bubble.left.and.bubble.right.fill"),
        .init(displayName: "Discord", category: "Social", systemIcon: "gamecontroller.fill"),
        .init(displayName: "Photos", category: "Media", systemIcon: "photo.fill.on.rectangle.fill"),
        .init(displayName: "Spotify", category: "Music", systemIcon: "music.note"),
    ]

    init() {
        self.guardedApps = Persistence.load([GuardedApp].self, key: StorageKeys.guardedApps, fallback: [])
        self.settings = Persistence.load(AppSettings.self, key: StorageKeys.settings, fallback: AppSettings())
        self.stats = Persistence.load(UsageStats.self, key: StorageKeys.stats, fallback: UsageStats())
        self.isPro = UserDefaults.standard.bool(forKey: StorageKeys.isPro)

        // First-run nicety
        if guardedApps.isEmpty {
            guardedApps = [.init(displayName: "Instagram", category: "Social", systemIcon: "camera")]
        }
    }

    var todaysSaves: Int {
        stats.dailySaves[todayKey()] ?? 0
    }

    func canAddMoreApps() -> Bool {
        isPro || guardedApps.count < settings.freeAppLimit
    }

    func toggleGuard(for app: GuardedApp) {
        if guardedApps.contains(app) {
            guardedApps.removeAll { $0.id == app.id }
        } else {
            guardedApps.append(app)
        }
    }

    func recordAutopilotSave(for app: GuardedApp) {
        // Update opens prevented for app
        if let idx = guardedApps.firstIndex(of: app) {
            guardedApps[idx].opensPrevented += 1
        }

        // Stats
        let key = todayKey()
        stats.dailySaves[key, default: 0] += 1
        stats.totalSaves += 1
    }

    func todayKey(_ date: Date = Date()) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }

    // Simple “streak” = consecutive days with >0 saves
    var streakDays: Int {
        let cal = Calendar.current
        var streak = 0
        var day = Date()
        while true {
            let key = todayKey(day)
            let count = stats.dailySaves[key, default: 0]
            if count > 0 {
                streak += 1
                day = cal.date(byAdding: .day, value: -1, to: day) ?? day
            } else {
                break
            }
        }
        return streak
    }
}
