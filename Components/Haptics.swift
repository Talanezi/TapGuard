//
//  Haptics.swift
//  TapGuard
//
//  Created by Thamer Alanezi on 12/25/25.
//

import UIKit

enum Haptics {
    static func tap(_ enabled: Bool) {
        guard enabled else { return }
        let gen = UIImpactFeedbackGenerator(style: .light)
        gen.impactOccurred()
    }

    static func success(_ enabled: Bool) {
        guard enabled else { return }
        let gen = UINotificationFeedbackGenerator()
        gen.notificationOccurred(.success)
    }
}
