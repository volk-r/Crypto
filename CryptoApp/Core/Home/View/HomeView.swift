//
//  HomeView.swift
//  CryptoApp
//
//  Created by Roman Romanov on 29.03.2026.
//

import SwiftUI

struct HomeView: View {

	@EnvironmentObject var viewModel: HomeViewModel
	@State private var showPortfolio: Bool = false

    var body: some View {
		ZStack {
			Color.theme.background
				.ignoresSafeArea()

			VStack {
				headerView

				SearchBarView(searchText: $viewModel.searchText)

				columnTitles

				if !showPortfolio {
					coinsList(
						viewModel.allCoins,
						showHoldings: false
					)
					.transition(.move(edge: .leading))
				} else {
					coinsList(
						viewModel.portfolioCoins,
						showHoldings: true
					)
					.transition(.move(edge: .trailing))
				}

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

	var columnTitles: some View {
		HStack {
			Text("Coin")
			Spacer()

			if showPortfolio {
				Text("Holdings")
			}
			Text("Price")
				.containerRelativeFrame(
					[.horizontal], alignment: .trailing
				) { length, axis in
					axis == .horizontal ? length / 3.5 : length
				}
		}
		.font(.caption)
		.foregroundStyle(Color.theme.secondaryText)
		.padding(.horizontal)
		.padding(.top, 10)
	}

	func coinsList(_ coins: [CoinModel], showHoldings: Bool) -> some View {
		List(coins) { coin in
			CoinRowView(coin: coin, showHoldingsColumn: showHoldings)
				.listRowInsets(
					EdgeInsets(
						top: 10,
						leading: 0,
						bottom: 10,
						trailing: 10
					)
				)
		}
		.listStyle(.plain)
	}
}

#Preview {
	NavigationStack {
		HomeView()
			.toolbarVisibility(.hidden)
	}
	.environmentObject(MockData.instance.homeVM)
}
