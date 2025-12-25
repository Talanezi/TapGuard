//
//  Presistence.swift
//  TapGuard
//
//  Created by Thamer Alanezi on 12/25/25.
//

import Foundation

enum StorageKeys {
    static let guardedApps = "tg_guardedApps"
    static let settings = "tg_settings"
    static let stats = "tg_stats"
    static let isPro = "tg_isPro"
}

final class Persistence {
    static func load<T: Decodable>(_ type: T.Type, key: String, fallback: T) -> T {
        guard let data = UserDefaults.standard.data(forKey: key) else { return fallback }
        do { return try JSONDecoder().decode(T.self, from: data) }
        catch { return fallback }
    }

    static func save<T: Encodable>(_ value: T, key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            // ignore in prototype
        }
    }
}
