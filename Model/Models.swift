//
//  Models.swift
//  TapGuard
//
//  Created by Thamer Alanezi on 12/25/25.
//

import Foundation

struct GuardedApp: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var displayName: String
    var category: String
    var systemIcon: String
    var iconAssetName: String? = nil // Optional: you can add custom icons later
    var opensPrevented: Int = 0
}

enum ConfirmMode: String, Codable, CaseIterable, Identifiable {
    case always
    case smartRecent
    var id: String { rawValue }

    var title: String {
        switch self {
        case .always: return "Always Confirm"
        case .smartRecent: return "Smart Confirm"
        }
    }

    var subtitle: String {
        switch self {
        case .always: return "Ask every time you open a guarded app."
        case .smartRecent: return "Only ask if you opened it recently."
        }
    }
}

struct AppSettings: Codable, Hashable {
    var guardEnabled: Bool = true
    var hapticsEnabled: Bool = true
    var animationsEnabled: Bool = true

    var confirmMode: ConfirmMode = .always
    var smartWindowMinutes: Int = 10

    // UI polish toggles
    var showTips: Bool = true
    var freeAppLimit: Int = 2
}

struct UsageStats: Codable, Hashable {
    // yyyy-MM-dd -> saves count
    var dailySaves: [String: Int] = [:]
    var totalSaves: Int = 0
}

enum PaywallPlan: String, CaseIterable, Identifiable {
    case weekly, monthly, yearly
    var id: String { rawValue }

    var title: String {
        switch self {
        case .weekly: return "Weekly"
        case .monthly: return "Monthly"
        case .yearly: return "Yearly"
        }
    }

    var price: String {
        switch self {
        case .weekly: return "$2.99"
        case .monthly: return "$9.99"
        case .yearly: return "$24.99"
        }
    }

    var badge: String? {
        switch self {
        case .yearly: return "Best Value"
        default: return nil
        }
    }
}
