//
//  CircleButtonAnimationView.swift
//  CryptoApp
//
//  Created by Roman Romanov on 29.03.2026.
//

import SwiftUI

struct CircleButtonAnimationView: View {

	@Binding var isAnimating: Bool

    var body: some View {
        Circle()
			.stroke(lineWidth: 5)
			.scale(isAnimating ? 1.5 : 0.5)
			.opacity(isAnimating ? 0 : 1)
			.foregroundStyle(Color.theme.accent)
			.animation(
				isAnimating ? .easeOut(duration: 1) : .none,
				value: isAnimating
			)
    }
}

#Preview {
	CircleButtonAnimationView(isAnimating: .constant(false))
		.foregroundStyle(Color.red)
		.frame(width: 100, height: 100)
}
