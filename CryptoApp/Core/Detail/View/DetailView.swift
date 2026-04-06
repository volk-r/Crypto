//
//  DetailView.swift
//  CryptoApp
//
//  Created by Roman Romanov on 05.04.2026.
//

import SwiftUI

struct DetailView: View {

	@StateObject private var viewModel: DetailViewModel
	@State private var showFullDescription: Bool = false

	private let column: [GridItem] = [
		GridItem(.flexible()),
		GridItem(.flexible())
	]
	private let spacing: CGFloat = 30

	init(coin: CoinModel) {
		_viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
	}

    var body: some View {
		ScrollView {
			VStack {
				ChartPickerView(coin: viewModel.coin)

				VStack(spacing: 20) {
					descriptionSection
					makeStatistics(
						title: "Overview",
						statistics: viewModel.overviewStatistics
					)
					makeStatistics(
						title: "Additional Details",
						statistics: viewModel.additionalStatistics
					)
					websiteSection
				}
				.padding()
			}
		}
		.navigationTitle(viewModel.coin.name)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				toolbarTrailingItem
			}
		}
    }
}

// MARK: - Private Methods

private extension DetailView {

	var toolbarTrailingItem: some View {
		HStack {
			Text(viewModel.coin.symbol.uppercased())
				.font(.headline)
				.foregroundStyle(Color.theme.secondaryText)
			CoinImageView(coin: viewModel.coin)
				.frame(width: 25, height: 25)
		}
		.padding(.horizontal, 6)
	}

	var descriptionSection: some View {
		VStack {
			if let coinDescription = viewModel.coinDescription,
			   !coinDescription.isEmpty {
				VStack(alignment: .leading) {
					Text(coinDescription)
						.lineLimit(showFullDescription ? .max : 3)
						.font(.callout)
						.foregroundStyle(Color.theme.secondaryText)
						.animation(showFullDescription ? .easeInOut : .none, value: showFullDescription)

					Button(action: {
						showFullDescription.toggle()
					}, label: {
						Text(showFullDescription ? "Less" : "Read more...")
							.font(.caption)
							.fontWeight(.bold)
							.padding(.vertical, 4)
					})
					.tint(.blue)
				}
				.frame(maxWidth: .infinity, alignment: .leading)
			}
		}
	}

	var websiteSection: some View {
		VStack(alignment: .leading, spacing: 20) {
			if let websiteString = viewModel.websiteURL,
			   let url = URL(string: websiteString) {
				Link("Website", destination: url)
			}

			if let redditString = viewModel.redditURL,
			   let url = URL(string: redditString) {
				Link("Reddit", destination: url)
			}
		}
		.tint(.blue)
		.frame(maxWidth: .infinity, alignment: .leading)
		.font(.headline)
	}

	func makeStatistics(
		title: String,
		statistics: [StatisticModel]
	) -> some View {
		VStack {
			Text(title)
				.font(.title)
				.bold()
				.foregroundStyle(Color.theme.accent)
				.frame(maxWidth: .infinity, alignment: .leading)

			Divider()

			LazyVGrid(
				columns: column,
				alignment: .leading,
				spacing: spacing
			) {
				ForEach(statistics) { stat in
					StatisticView(stat: stat)
				}
			}
		}
	}
}

#Preview {
	NavigationStack {
		DetailView(coin: MockData.instance.coin)
	}
}
