//
//  MarketDataService.swift
//  CryptoApp
//
//  Created by Roman Romanov on 03.04.2026.
//

import Combine
import Foundation

final class MarketDataService: ObservableObject {

	@Published var marketData: MarketDataModel?

	private var marketDataSubscription: AnyCancellable?

	init() {
		getData()
	}

	private func getData() {
		guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }

		marketDataSubscription = NetworkManager.download(url: url)
			.decode(type: GlobalData.self, decoder: JSONDecoder())
			.sink { completion in
				NetworkManager.handleCompletion(completion: completion)
			} receiveValue: { [weak self] returnedGlobalData in
				self?.marketData = returnedGlobalData.data
				self?.marketDataSubscription?.cancel()
			}
	}
}
