//
//  HomeView.swift
//  CryptoApp
//
//  Created by Roman Romanov on 29.03.2026.
//

import SwiftUI

struct HomeView: View {

	@State private var showPortfolio: Bool = false

    var body: some View {
		ZStack {
			Color.theme.background
				.ignoresSafeArea()

			VStack {
				headerView
				Spacer(minLength: 0)
			}
		}
    }
}

private extension HomeView {

	var headerView: some View {
		HStack {
			CircleButtonView(iconName: showPortfolio ? "plus" : "info")
				.animation(.none, value: showPortfolio)
				.background {
					CircleButtonAnimationView(isAnimating: $showPortfolio)
				}
			Spacer()
			Text(showPortfolio ? "Portfolio" : "Live Prices")
				.font(.headline)
				.fontWeight(.heavy)
				.foregroundStyle(Color.theme.accent)
				// like as .animation(.none, value: showPortfolio)
				.transaction { transaction in
					   transaction.animation = nil
				}
			Spacer()
			CircleButtonView(iconName: "chevron.right")
				.rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
				.onTapGesture {
					withAnimation(.spring) {
						showPortfolio.toggle()
					}
				}
		}
		.padding(.horizontal)
	}
}

#Preview {
	NavigationStack {
		HomeView()
	}
	.toolbarVisibility(.hidden)
}
