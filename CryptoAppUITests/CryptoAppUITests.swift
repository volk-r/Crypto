//
//  CryptoAppUITests.swift
//  CryptoAppUITests
//
//  Created by Roman Romanov on 09.04.2026.
//

import XCTest

final class CryptoAppUITests: XCTestCase {

	private let app = XCUIApplication()

	override func setUpWithError() throws {
		continueAfterFailure = false
		app.launch()
	}

	override func tearDownWithError() throws {
		try super.tearDownWithError()
		app.terminate()
	}

	@MainActor
	func testSearchBar() throws {
		let myText = "BTC"
		let searchBar = app.textFields[AppAccessibilityId.SearchBar.searchField]
		XCTAssertTrue(searchBar.waitForExistence(timeout: 10), "SearchBar not found")
		searchBar.tap()
		// Launch overlay animation can steal the first tap
		if !app.keyboards.element.waitForExistence(timeout: 2) {
			searchBar.tap()
			XCTAssertTrue(app.keyboards.element.waitForExistence(timeout: 2))
		}
		searchBar.typeText(myText)

		XCTAssertTrue(app.staticTexts[myText].waitForExistence(timeout: 2))
	}

	private func getInfoButton(element: String) -> XCUIElement {
		let predicate = NSPredicate(
			format: "identifier == %@",
			element
		)
		let infoButton = app
			.descendants(matching: .any)
			.matching(predicate)
			.firstMatch
		return infoButton
	}

	private func waitForLaunchScreenToDisappear(timeout: TimeInterval = 5) {
		let launchScreen = getInfoButton(element: AppAccessibilityId.LaunchScreen.id)
		XCTAssertTrue(launchScreen.waitForNonExistence(timeout: timeout), "Launch screen did not disappear in time")
	}

	private func tapInfoButton() {
		let infoButton = getInfoButton(element: AppAccessibilityId.CircleButton.navBarLeft)
		XCTAssertTrue(infoButton.waitForExistence(timeout: 10), "Info button not found")
		waitForLaunchScreenToDisappear()
		XCTAssertTrue(infoButton.isHittable, "Info button is not hittable")
		infoButton.tap()
	}

	@MainActor
	func testOpenSettingsScreen() throws {
		tapInfoButton()

		let settingsScreen = app.navigationBars[AppAccessibilityId.Settings.screenTitle]
		let exists = settingsScreen.waitForExistence(timeout: 5)
		XCTAssertTrue(exists, "Settings screen did not appear")
	}

	@MainActor
	func testOpenAndCloseSettingsScreen() throws {
		tapInfoButton()

		let closeButton = app.buttons[AppAccessibilityId.XMarkButton.id]
		let exists = closeButton.waitForExistence(timeout: 5)
		XCTAssertTrue(exists, "Close button did not appear on the screen")

		closeButton.tap()
		XCTAssertTrue(closeButton.waitForNonExistence(timeout: 3), "Settings screen did not closed")
	}
}
