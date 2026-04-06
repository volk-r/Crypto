//
//  ChartHorizontalView.swift
//  CryptoApp
//
//  Created by Roman Romanov on 06.04.2026.
//

import Charts
import SwiftUI

struct ChartHorizontalView: View {

	@State private var animatePercentage: CGFloat = 0

	private let data: [Double]
	private let maxY: Double
	private let minY: Double
	private let lineColor: Color
	private let startingDate: Date
	private let endingDate: Date

	init(coin: CoinModel) {
		data = coin.sparklineIn7D?.price ?? []
		maxY = data.max() ?? 0
		minY = data.min() ?? 0

		let priceChange = (data.last ?? 0) - (data.first ?? 0)
		lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red

		endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
		startingDate = endingDate.addingTimeInterval(-7 * 24 * 60 * 60)
	}

	var body: some View {
		VStack(spacing: 4) {
			makeChartView(lineColor: lineColor)
			// A mask to make the animation run from left to right
			.mask(
				GeometryReader { geo in
					Rectangle()
						.frame(width: geo.size.width * animatePercentage)
				}
			)
			.frame(height: 200)
			.background(makeChartView(lineColor: .clear))

			shortDateLabels
		}
		.font(.caption)
		.foregroundColor(Color.theme.secondaryText)
		.padding(.horizontal, 4)
		.onAppear {
			withAnimation(.linear(duration: 2)) {
				animatePercentage = 1
			}
		}
	}
}

// MARK: - Private Methods

private extension ChartHorizontalView {

	func makeChartView(lineColor: Color) -> some View {
		Chart {
			let step = endingDate.timeIntervalSince(startingDate) / Double(max(data.count - 1, 1))

			ForEach(Array(data.enumerated()), id: \.offset) { index, value in
				let date = startingDate.addingTimeInterval(Double(index) * step)
				// Line
				LineMark(
					x: .value("Day", date),
					y: .value("Price", value)
				)
				.interpolationMethod(.monotone)
				.foregroundStyle(lineColor)
				.shadow(color: lineColor, radius: 10, y: 10)
				.shadow(color: lineColor.opacity(0.5), radius: 10, y: 20)
				.shadow(color: lineColor.opacity(0.2), radius: 10, y: 30)
				.shadow(color: lineColor.opacity(0.1), radius: 10, y: 40)
			}
		}
		.chartYScale(domain: minY...maxY)
		.chartXAxis {
			AxisMarks(values: .automatic(desiredCount: 5)) {
				AxisGridLine()
				AxisTick()
				AxisValueLabel(format: .dateTime.day().month())
			}
		}
	}

	var shortDateLabels: some View {
		HStack {
			Text(startingDate.asShortDateString())
			Spacer()
			Text(endingDate.asShortDateString())
		}
	}
}

#Preview {
	ChartHorizontalView(coin: MockData.instance.coin)
}
