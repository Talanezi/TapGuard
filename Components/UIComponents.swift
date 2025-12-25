//
//  UIComponents.swift
//  TapGuard
//
//  Created by Thamer Alanezi on 12/25/25.
//

import SwiftUI

struct TGCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }

    var body: some View {
        content
            .padding(Theme.cardPadding)
            .background(Theme.glassBackground(), in: RoundedRectangle(cornerRadius: Theme.cardCorner, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cardCorner, style: .continuous)
                    .strokeBorder(.primary.opacity(0.08))
            )
    }
}

struct PrimaryButton: View {
    var title: String
    var systemImage: String? = nil
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if let systemImage { Image(systemName: systemImage) }
                Text(title).font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }
}

struct Pill: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.thinMaterial, in: Capsule())
    }
}

struct AnimatedNumber: View {
    var value: Int
    @State private var displayed: Int = 0

    var body: some View {
        Text("\(displayed)")
            .contentTransition(.numericText())
            .onAppear { displayed = value }
            .onChange(of: value) { _, newValue in
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    displayed = newValue
                }
            }
    }
}

struct ProgressRing: View {
    var progress: Double // 0...1
    var lineWidth: CGFloat = 10

    var body: some View {
        ZStack {
            Circle().stroke(.primary.opacity(0.12), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: max(0, min(progress, 1)))
                .stroke(.tint, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.5, dampingFraction: 0.85), value: progress)
        }
    }
}
