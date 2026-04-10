//
//  DateExtUnitTests.swift
//  CryptoAppUnitTests
//
//  Created by Roman Romanov on 10.04.2026.
//

import Foundation
import Testing
@testable import CryptoApp

struct DateExtUnitTests {

	@Test("init(coinGeckoString:) parses a CoinGecko ISO string in UTC")
	func coinGeckoString_parsesKnownInstant() {
		let parsed = Date(coinGeckoString: "2021-03-13T20:49:26.606Z")
		var calendar = Calendar(identifier: .gregorian)
		calendar.timeZone = TimeZone(secondsFromGMT: 0)!
		let date = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: parsed)
		#expect(date.year == 2021)
		#expect(date.month == 3)
		#expect(date.day == 13)
		#expect(date.hour == 20)
		#expect(date.minute == 49)
		#expect(date.second == 26)
	}

	@Test(
		"init(coinGeckoString:) for multiple valid strings",
		arguments: [
			"2021-03-13T20:49:26.606Z",
			"2013-07-06T00:00:00.000Z",
		]
	)
	func coinGeckoString_acceptsSampleStrings(_ string: String) {
		let date = Date(coinGeckoString: string)
		#expect(date.timeIntervalSince1970 > 0)
	}

	@Test("asShortDateString() matches the same formatter used in the application")
	func asShortDateString_matchesAppFormatter() {
		let date = Date(coinGeckoString: "2021-03-13T20:49:26.606Z")
		let fromExtension = date.asShortDateString()
		let fromFormatter = AppDateFormatters.short.string(from: date)
		#expect(fromExtension == fromFormatter)
	}

	@Test("asShortDateString() is a fixed string for en_US + UTC")
	func asShortDateString_fixedOutput() {
		let date = Date(coinGeckoString: "2021-03-13T20:49:26.606Z")
		#expect(date.asShortDateString() == "3/14/21")
	}
}
