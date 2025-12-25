//
//  Theme.swift
//  TapGuard
//
//  Created by Thamer Alanezi on 12/25/25.
//

import SwiftUI

enum Theme {
    // Uses your app's accent color. Replace with Color("Tint") if you add a Color asset.
    static let tint: Color = .blue

    static let cardCorner: CGFloat = 20
    static let cardPadding: CGFloat = 16

    static func glassBackground() -> some ShapeStyle {
        // Looks good on both light/dark without forcing a theme
        .ultraThinMaterial
    }
}
