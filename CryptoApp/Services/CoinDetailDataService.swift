//
//  CoinDetailDataService.swift
//  CryptoApp
//
//  Created by Roman Romanov on 05.04.2026.
//

import Combine
import Foundation

final class CoinDetailDataService: ObservableObject {

	@Published var coinDetails: CoinDetailModel?

	private let coin: CoinModel

	private var coinDetailSubscription: AnyCancellable?

	init(coin: CoinModel) {
		self.coin = coin
		getCoinDetails()
	}

	func getCoinDetails() {
		guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }

		coinDetailSubscription = NetworkManager.download(url: url)
			.decode(type: CoinDetailModel.self, decoder: JSONDecoder())
			.receive(on: DispatchQueue.main)
			.sink { completion in
				NetworkManager.handleCompletion(completion: completion)
			} receiveValue: { [weak self] returnedCoinDetails in
				self?.coinDetails = returnedCoinDetails
				self?.coinDetailSubscription?.cancel()
			}
	}
}
