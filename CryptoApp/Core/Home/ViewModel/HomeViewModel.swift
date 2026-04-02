//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Roman Romanov on 31.03.2026.
//

import Combine
import Foundation

final class HomeViewModel: ObservableObject {

	@Published var allCoins: [CoinModel] = []
	@Published var portfolioCoins: [CoinModel] = []

	@Published var searchText: String = ""

	private let dataService = CoinDataService()
	private var cancellables: Set<AnyCancellable> = []

	init() {
		addSubscribers()
	}

	func addSubscribers() {
		// update allCoins
		$searchText
			.combineLatest(dataService.$allCoins)
			.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
			.map(filterCoins)
			.sink { [weak self] returnedCoins in
				self?.allCoins = returnedCoins
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
}
