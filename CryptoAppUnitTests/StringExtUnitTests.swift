//
//  StringExtUnitTests.swift
//  CryptoAppUnitTests
//
//  Created by Roman Romanov on 10.04.2026.
//

import XCTest
@testable import CryptoApp

final class StringExtUnitTests: XCTestCase {

	func testRemovingHTMLOccurances() {
		let htmlString = "<a class=\"prc-ActionList-ActionListContent-KBb8- prc-Link-Link-9ZwDx\" tabindex=\"0\"  href=\"https://github.com/volk-r\" data-discover=\"true\"><span class=\"prc-ActionList-Spacer-4tR2m\">Volk-r's Profile</span></a>"
		XCTAssertEqual(htmlString.removingHTMLOccurances, "Volk-r's Profile", "HTML tags should be removed")
	}
}
