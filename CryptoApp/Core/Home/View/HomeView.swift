//
//  HomeView.swift
//  CryptoApp
//
//  Created by Roman Romanov on 29.03.2026.
//

import SwiftUI

struct HomeView: View {

	@EnvironmentObject var viewModel: HomeViewModel
	@State private var showPortfolio: Bool = false // animate right
	@State private var showPortfolioView: Bool = false // new sheet
	@State private var showSettingsView: Bool = false // new sheet

    var body: some View {
		ZStack {
			Color.theme.background
				.ignoresSafeArea()
				.sheet(isPresented: $showPortfolioView) {
					PortfolioView()
				}

			VStack {
				headerView
				HomeStatsView(showPortfolio: $showPortfolio)
				SearchBarView(searchText: $viewModel.searchText)

				columnTitles

				if !showPortfolio {
					coinsList(
						viewModel.allCoins,
						showHoldings: false
					)
					.transition(.move(edge: .leading))
				} else {
					ZStack {
						ZStack(alignment: .top) {
							if viewModel.portfolioCoins.isEmpty && viewModel.searchText.isEmpty {
								portfolioEmptyText
							} else {
								coinsList(
									viewModel.portfolioCoins,
									showHoldings: true
								)
							}
						}
					}
					.transition(.move(edge: .trailing))
				}

				Spacer(minLength: 0)
			}
			.sheet(isPresented: $showSettingsView) {
				SettingsView()
			}
		}
    }
}

private extension HomeView {

	var headerView: some View {
		HStack {
			CircleButtonView(iconName: showPortfolio ? "plus" : "info")
				.animation(.none, value: showPortfolio)
				.onTapGesture {
					showPortfolio == true
						? showPortfolioView.toggle()
					    : showSettingsView.toggle()
				}
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
		.padding(.bottom, 10)
	}

	var columnTitles: some View {
		HStack {
			HStack(spacing: 4) {
				Text("Coin")
				Image(systemName: "chevron.down")
					.opacity(
						[.rank, .rankReversed]
							.contains(viewModel.sortOption) ? 1 : 0
					)
					.rotation3DEffect(
						Angle.degrees(viewModel.sortOption == .rank ? 0 : 180),
						axis: (x: 1, y: 0, z: 0)
					)
			}
			.onTapGesture {
				withAnimation {
					viewModel.sortOption = viewModel.sortOption == .rank ? .rankReversed : .rank
				}
			}

			Spacer()

			if showPortfolio {
				HStack(spacing: 4) {
					Text("Holdings")
					Image(systemName: "chevron.down")
						.opacity(
							[.holdings, .holdingsReversed]
								.contains(viewModel.sortOption) ? 1 : 0
						)
						.rotation3DEffect(
							Angle.degrees(viewModel.sortOption == .holdings ? 0 : 180),
							axis: (x: 1, y: 0, z: 0)
						)
				}
				.onTapGesture {
					withAnimation {
						viewModel.sortOption = viewModel.sortOption == .holdings ? .holdingsReversed : .holdings
					}
				}
			}
			HStack(spacing: 4) {
				Text("Price")
				Image(systemName: "chevron.down")
					.opacity(
						[.price, .priceReversed]
							.contains(viewModel.sortOption) ? 1 : 0
					)
					.rotation3DEffect(
						Angle.degrees(viewModel.sortOption == .price ? 0 : 180),
						axis: (x: 1, y: 0, z: 0)
					)
			}
			.containerRelativeFrame(
				[.horizontal], alignment: .trailing
			) { length, axis in
				axis == .horizontal ? length / 3.5 : length
			}
			.onTapGesture {
				withAnimation {
					viewModel.sortOption = viewModel.sortOption == .price ? .priceReversed : .price
				}
			}

			Button {
				withAnimation(.linear(duration: 2)) {
					viewModel.reloadData()
				}
			} label: {
				Image(systemName: "goforward")
			}
			.rotationEffect(
				Angle(degrees: viewModel.isLoading ? 360 : 0),
				anchor: .center
			)
		}
		.font(.caption)
		.foregroundStyle(Color.theme.secondaryText)
		.padding(.horizontal)
	}

	var portfolioEmptyText: some View {
		Text("You haven't any coins to your portfolio yet! Click the + button to get started! 🧐")
			.font(.callout)
			.foregroundStyle(Color.theme.accent)
			.fontWeight(.medium)
			.multilineTextAlignment(.center)
			.padding(50)
	}

	func coinsList(_ coins: [CoinModel], showHoldings: Bool) -> some View {
		List(coins) { coin in
			NavigationLink(value: coin) {
				CoinRowView(coin: coin, showHoldingsColumn: showHoldings)
			}
			.listRowBackground(Color.clear)
			.listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
			.navigationLinkIndicatorVisibility(.hidden)
		}
		.listStyle(.plain)
		.refreshable { viewModel.reloadData() }
		.navigationDestination(for: CoinModel.self) { coin in
			DetailView(coin: coin)
		}
	}
}

#Preview {
	NavigationStack {
		HomeView()
			.toolbarVisibility(.hidden)
	}
	.environmentObject(MockData.instance.homeVM)
}
