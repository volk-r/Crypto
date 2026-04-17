//
//  LaunchView.swift
//  CryptoApp
//
//  Created by Roman Romanov on 07.04.2026.
//

import Combine
import SwiftUI

struct LaunchView: View {

	@Binding var showLaunchView: Bool

	@State private var loadingText: [String] = "Loading your portfolio...".map { String($0) }
	@State private var showLoadingText: Bool = false

	@State private var counter: Int = 0
	@State private var loops: Int = 0

	private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
		ZStack {
			Color.launch.background
				.ignoresSafeArea()

			Image(.Images.logoTransparent)
				.resizable()
				.frame(width: 100, height: 100)

			ZStack {
				if showLoadingText {
					HStack(spacing: 0) {
						ForEach(loadingText.indices, id: \.self) { index in
							Text(loadingText[index])
								.font(.headline)
								.fontWeight(.heavy)
								.foregroundStyle(Color.launch.accent)
								.offset(y: counter == index ? -5 : 0)
						}
					}
					.transition(.scale.animation(.easeIn))
				}
			}
			.offset(y: 70)
		}
		.onAppear {
			showLoadingText.toggle()
		}
		.onReceive(timer) { _ in
			let lastIndex = loadingText.count - 1
			if lastIndex == counter {
				loops += 1
				if loops >= 2 {
					withAnimation {
						showLaunchView = false
					}
				}
			}
			withAnimation(.easeIn) {
				counter = lastIndex == counter ? 0 : counter + 1
			}
		}
		.accessibilityIdentifier(AppAccessibilityId.LaunchScreen.id)
    }
}

#Preview {
	LaunchView(showLaunchView: .constant(true))
}
