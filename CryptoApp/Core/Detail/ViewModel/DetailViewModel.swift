//
//  DetailViewModel.swift
//  CryptoApp
//
//  Created by Roman Romanov on 05.04.2026.
//

import Combine
import Foundation

final class DetailViewModel: ObservableObject {

	// MARK: - Public Properties

	@Published var overviewStatistics: [StatisticModel] = []
	@Published var additionalStatistics: [StatisticModel] = []
	@Published var coinDescription: String?
	@Published var websiteURL: String?
	@Published var redditURL: String?

	@Published var coin: CoinModel

	// MARK: - Private Properties

	private let coinDetailService: CoinDetailDataService

	private var cancellables: Set<AnyCancellable> = []

	// MARK: - init

	init(coin: CoinModel) {
		self.coin = coin
		coinDetailService = CoinDetailDataService(coin: coin)
		addSubscribers()
	}
}

// MARK: - Private Methods

private extension DetailViewModel {

	func addSubscribers() {
		coinDetailService.$coinDetails
			.combineLatest($coin)
			.map(mapDataToStatistics)
			.sink { [weak self] returnedArrays in
				self?.overviewStatistics = returnedArrays.overview
				self?.additionalStatistics = returnedArrays.additional
			}
			.store(in: &cancellables)

		coinDetailService.$coinDetails
			.sink { [weak self] returnedCoinDetails in
				self?.coinDescription = returnedCoinDetails?.readableDescription
				self?.websiteURL = returnedCoinDetails?.links?.homepage?.first
				self?.redditURL = returnedCoinDetails?.links?.subredditURL
			}
			.store(in: &cancellables)
	}

	func mapDataToStatistics(
		coinDetailModel: CoinDetailModel?,
		coinModel: CoinModel
	) -> (
		overview: [StatisticModel],
		additional: [StatisticModel]
	) {
		let overviewArray = createOverviewArray(coinModel: coinModel)
		let additionalArray = createAdditionalArray(coinModel: coinModel, coinDetailModel: coinDetailModel)

		return (overviewArray, additionalArray)
	}

	func createOverviewArray(coinModel: CoinModel) -> [StatisticModel] {
		let price = coinModel.currentPrice.asCurrencyWith6Decimals()
		let pricePercentChange = coinModel.priceChangePercentage24H
		let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentChange)

		let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
		let marketCapPercentChange = coinModel.marketCapChangePercentage24H
		let marketCapStat = StatisticModel(title: "Market Cap", value: marketCap, percentageChange: marketCapPercentChange)

		let rank = coinModel.rank.description
		let rankStat = StatisticModel(title: "Rank", value: rank)

		let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
		let volumeStat = StatisticModel(title: "Volume", value: volume)

		let overviewArray: [StatisticModel] = [
			priceStat, marketCapStat, rankStat, volumeStat
		]

		return overviewArray
	}

	func createAdditionalArray(
		coinModel: CoinModel,
		coinDetailModel: CoinDetailModel?
	) -> [StatisticModel] {
		let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
		let highStat = StatisticModel(title: "24h High", value: high)

		let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
		let lowStat = StatisticModel(title: "24h Low", value: low)

		let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
		let pricePercentChange = coinModel.priceChangePercentage24H
		let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange)

		let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
		let marketCapPercentChange = coinModel.marketCapChangePercentage24H
		let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)

		let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
		let blockTimeString = blockTime == 0 ? "n/a" : blockTime.description
		let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)

		let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
		let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)

		let additionalArray: [StatisticModel] = [
			highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
		]

		return additionalArray
	}
}
