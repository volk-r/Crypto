//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Roman Romanov on 31.03.2026.
//

import Combine
import Foundation

@Observable
final class HomeViewModel {

	var allCoins: [CoinModel] = []
	var portfolioCoins: [CoinModel] = []

	private let dataService = CoinDataService()
	private var cancellables: Set<AnyCancellable> = []

	init() {
		addSubscribers()
	}

	func addSubscribers() {
		dataService.$allCoins
			.sink { [weak self] returnedCoins in
				self?.allCoins = returnedCoins
			}
			.store(in: &cancellables)
	}
}
