//
//  PortfolioView.swift
//  CryptoApp
//
//  Created by Roman Romanov on 03.04.2026.
//

import SwiftUI

struct PortfolioView: View {

	@EnvironmentObject var viewModel: HomeViewModel
	@State private var selectedCoin: CoinModel?
	@State private var quantityText: String = ""
	@State private var showCheckMark: Bool = false

	@FocusState private var isFocused: Bool

	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(alignment: .leading, spacing: 0) {
					SearchBarView(searchText: $viewModel.searchText)
					coinLogoList

					if selectedCoin != nil {
						portfolioInputSection
					}
				}
			}
			.navigationTitle("Edit Portfolio")
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					XMarkButton()
				}
				if showCheckMark || selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) {
					ToolbarItem(placement: .topBarTrailing) {
						trailingNavBarButton
					}
				}
			}
		}
	}
}

private extension PortfolioView {

	var coinLogoList: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			LazyHStack(spacing: 10) {
				ForEach(viewModel.allCoins) { coin in
					CoinLogoView(coin: coin)
						.frame(width: 75)
						.padding(4)
						.onTapGesture {
							withAnimation(.easeIn) {
								selectedCoin = coin
							}
						}
						.background {
							RoundedRectangle(cornerRadius: 10)
								.stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth: 1)
						}
				}
			}
			.frame(height: 102)
			.padding(.leading)
		}
	}

	func getCurrentValue() -> Double {
		guard let quantity = Double(quantityText) else { return 0 }
		return quantity * (selectedCoin?.currentPrice ?? 0)
	}

	var portfolioInputSection: some View {
		VStack(spacing: 20) {
			HStack {
				Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
				Spacer()
				Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
			}
			Divider()
			HStack {
				Text("Amount holdings:")
				Spacer()
				TextField("Ex: 1.4", text: $quantityText)
					.multilineTextAlignment(.trailing)
					.keyboardType(.decimalPad)
					.focused($isFocused)
			}
			Divider()
			HStack {
				Text("Current Value:")
				Spacer()
				Text(getCurrentValue().asCurrencyWith2Decimals())
			}
		}
		.transaction { transaction in
			transaction.animation = nil
		}
		.padding()
		.font(.headline)
	}

	var trailingNavBarButton: some View {
		HStack(spacing: 10) {
			if showCheckMark {
				Image(systemName: "checkmark")
					.opacity(showCheckMark ? 1 : 0)
			}

			Button {
				saveButtonPressed()
			} label: {
				Text(showCheckMark ? "Saved" : "Save".uppercased())
			}
			.opacity(selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) ? 1 : 0)
		}
		.font(.headline)
		.padding(.horizontal, 4)
	}

	func saveButtonPressed() {
		guard selectedCoin != nil else { return }

		// save to portfolio

		// show checkmark
		withAnimation(.easeIn) {
			showCheckMark = true
		}

		// hide keyboard
		isFocused = false

		// hide checkmark
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			withAnimation(.easeOut) {
				showCheckMark = false
				removeSelectedCoin()
			}
		}
	}

	func removeSelectedCoin() {
		selectedCoin = nil
		viewModel.searchText = ""
		quantityText = ""
	}
}

#Preview {
	PortfolioView()
		.environmentObject(MockData.instance.homeVM)
}
