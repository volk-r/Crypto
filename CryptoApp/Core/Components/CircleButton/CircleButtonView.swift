//
//  CircleButtonView.swift
//  CryptoApp
//
//  Created by Roman Romanov on 29.03.2026.
//

import SwiftUI

struct CircleButtonView: View {

	let iconName: String

    var body: some View {
        Image(systemName: iconName)
			.font(.headline)
			.foregroundStyle(Color.theme.accent)
			.frame(width: 50, height: 50)
			.background {
				Circle()
					.foregroundStyle(Color.theme.background)
			}
			.shadow(
				color: .theme.accent.opacity(0.25),
				radius: 10, x: 0, y: 0)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
	CircleButtonView(iconName: "info")

	CircleButtonView(iconName: "plus")
		.padding(10)
}
