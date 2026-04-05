//
//  DetailView.swift
//  CryptoApp
//
//  Created by Roman Romanov on 05.04.2026.
//

import SwiftUI

struct DetailView: View {

	@StateObject private var viewModel: DetailViewModel

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
			VStack(spacing: 20) {
				Text("Details")
					.frame(height: 150)
				makeStatistics(
					title: "Overview",
					statistics: viewModel.overviewStatistics
				)
				makeStatistics(
					title: "Additional Details",
					statistics: viewModel.additionalStatistics
				)
			}
			.padding()
		}
		.navigationTitle(viewModel.coin.name)
    }
}

private extension DetailView {

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
