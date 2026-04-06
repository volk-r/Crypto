//
//  ChartPickerView.swift
//  CryptoApp
//
//  Created by Roman Romanov on 06.04.2026.
//

import SwiftUI

struct ChartPickerView: View {

	let coin: CoinModel

	@State private var selectedChart: ChartType = .horizontal

	var body: some View {
		Picker("Charts", selection: $selectedChart) {
			ForEach(ChartType.allCases, id: \.self) { chart in
				Text(chart.title).tag(chart)
			}
		}
		.pickerStyle(.segmented)
		.padding(.top)
		.padding(.horizontal)

		selectedChart.makeView(coin: coin)
			.padding(.vertical)
	}
}

// MARK: - Private Methods

private extension ChartPickerView {

	enum ChartType: String, CaseIterable {
		case horizontal
		case vertical
		case custom

		var title: String {
			rawValue.capitalized
		}

		@ViewBuilder
		func makeView(coin: CoinModel) -> some View {
			switch self {
			case .horizontal:
				ChartHorizontalView(coin: coin)
			case .vertical:
				ChartVerticalView(coin: coin)
			case .custom:
				ChartView(coin: coin)
			}
		}
	}
}

#Preview {
	ChartPickerView(coin: MockData.instance.coin)
}
