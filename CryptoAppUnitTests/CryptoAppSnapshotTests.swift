//
//  CryptoAppSnapshotTests.swift
//  CryptoAppUITests
//
//  Created by Roman Romanov on 10.04.2026.
//

import SnapshotTesting
import XCTest
import SwiftUI

@testable import CryptoApp

extension SwiftUI.View {

	func toVC() -> UIViewController {
		let vc = UIHostingController(rootView: self)
        // Size the hosting controller's view using context-derived information to avoid UIScreen.main
        // Prefer trait-based sizing where possible. Fall back to a reasonable default iPhone size for tests.
        let defaultSize = CGSize(width: 390, height: 844) // iPhone 15/13/12 size
        let scale = vc.traitCollection.displayScale
        if let windowScene = vc.view.window?.windowScene, let screen = windowScene.screen as UIScreen? {
            vc.view.frame = CGRect(origin: .zero, size: screen.bounds.size)
            vc.view.contentScaleFactor = screen.scale
        } else {
            // Window isn’t attached yet in tests; use traitCollection when available.
            vc.view.frame = CGRect(origin: .zero, size: defaultSize)
            vc.view.contentScaleFactor = scale
        }
		return vc
	}
}

final class CryptoAppSnapshotTests: XCTestCase {

	func testHomeView() {
		let view = HomeView()
		assertSnapshot(
			of: view
				.environmentObject(MockData.instance.homeVM)
				.colorScheme(.light)
				.toVC(),
			as: .image
		)
	}

	func testHomeViewDarkTheme() {
		let view = HomeView()
		assertSnapshot(
			of: view
				.environmentObject(MockData.instance.homeVM)
				.colorScheme(.dark)
				.toVC(),
			as: .image
		)
	}

	func testSettingsView() {
		let view = SettingsView()
		assertSnapshot(
			of: view
				.colorScheme(.light)
				.toVC(),
			as: .image
		)
	}

	func testSettingsViewDarkTheme() {
		let view = SettingsView()
		assertSnapshot(
			of: view
				.colorScheme(.dark)
				.toVC(),
			as: .image
		)
	}

	func testCoinRowView() {
		let view = CoinRowView(coin: MockData.instance.coin, showHoldingsColumn: true)
		assertSnapshot(
			of: view
				.colorScheme(.light)
				.toVC(),
			as: .image(traits: UITraitCollection(userInterfaceStyle: .light))
		)
	}

	func testCoinRowViewDarkTheme() {
		let view = CoinRowView(coin: MockData.instance.coin, showHoldingsColumn: true)
		assertSnapshot(
			of: view
				.colorScheme(.dark)
				.toVC(),
			as: .image(traits: UITraitCollection(userInterfaceStyle: .dark))
		)
	}

	func testHomeStatsView() {
		let view = StatisticView(stat: MockData.instance.stat1)
		assertSnapshot(
			of: view
				.colorScheme(.light)
				.toVC(),
			as: .image(traits: UITraitCollection(userInterfaceStyle: .light))
		)
	}

	func testHomeStatsViewDarkTheme() {
		let view = StatisticView(stat: MockData.instance.stat1)
		assertSnapshot(
			of: view
				.colorScheme(.dark)
				.toVC(),
			as: .image(traits: UITraitCollection(userInterfaceStyle: .dark))
		)
	}
}

