//
//  CoinDataService.swift
//  CryptoApp
//
//  Created by Roman Romanov on 01.04.2026.
//

import Combine
import Foundation

final class CoinDataService: ObservableObject {

	@Published var allCoins: [CoinModel] = []

	private var coinSubscription: AnyCancellable?

	init() {
		getCoins()
	}

	func getCoins() {
		guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }

		coinSubscription = NetworkManager.download(url: url)
			.decode(type: [CoinModel].self, decoder: JSONDecoder())
			.receive(on: DispatchQueue.main)
			.sink { completion in
				NetworkManager.handleCompletion(completion: completion)
			} receiveValue: { [weak self] returnedCoins in
				self?.allCoins = returnedCoins
				self?.coinSubscription?.cancel()
			}
	}
}
