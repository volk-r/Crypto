//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Roman Romanov on 31.03.2026.
//

import Combine
import Foundation

final class HomeViewModel: ObservableObject {

	@Published var statistics: [StatisticModel] = []

	@Published var allCoins: [CoinModel] = []
	@Published var portfolioCoins: [CoinModel] = []

	@Published var searchText: String = ""

	private let coinDataService = CoinDataService()
	private let marketDataService = MarketDataService()
	private var cancellables: Set<AnyCancellable> = []

	init() {
		addSubscribers()
	}

	func addSubscribers() {
		// update allCoins
		$searchText
			.combineLatest(coinDataService.$allCoins)
			.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
			.map(filterCoins)
			.sink { [weak self] returnedCoins in
				self?.allCoins = returnedCoins
			}
			.store(in: &cancellables)
		// update marketData
		marketDataService.$marketData
			.map(mapGlobalMarkets)
			.sink { [weak self] returnedStats in
				self?.statistics = returnedStats
			}
			.store(in: &cancellables)
	}

	private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
		guard !text.isEmpty else { return coins }

		let lowercaseText = text.lowercased()
		return coins.filter { coin in
			coin.name.lowercased().contains(lowercaseText)
			|| coin.symbol.lowercased().contains(lowercaseText)
			|| coin.id.lowercased().contains(lowercaseText)
		}
	}

	private func mapGlobalMarkets(marketDataModel: MarketDataModel?) -> [StatisticModel] {
		var stats: [StatisticModel] = []

		guard let statData = marketDataModel else { return stats }

		let marketCap = StatisticModel(
			title: "Market Cap",
			value: statData.marketCap,
			percentageChange: statData.marketCapChangePercentage24HUsd
		)
		let volume = StatisticModel(title: "24h Volume", value: statData.volume)
		let btcDominance = StatisticModel(title: "BTC Dominance", value: statData.btcDominance)
		let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)

		stats.append(contentsOf: [
			marketCap,
			volume,
			btcDominance,
			portfolio
		])

		return stats
	}
}
