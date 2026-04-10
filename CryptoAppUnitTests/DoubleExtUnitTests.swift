//
//  DoubleExtUnitTests.swift
//  CryptoAppUnitTests
//
//  Created by Roman Romanov on 10.04.2026.
//

import Testing
import Foundation
@testable import CryptoApp

struct DoubleExtUnitTests {

	@Test(
		"Converts a Double into a Currency as a String with 2 decimal places",
		arguments: [
			1234.56,
			1234.563
		]
	)
    func asCurrencyWith2Decimals(_ number: Double) async throws {
		let numberFormattedString = "$1,234.56"
		let result = number.asCurrencyWith2Decimals()
		#expect(result == numberFormattedString)
    }

	@Test func `Failed converts a Double into a Currency as a String with 2 decimal places`() async throws {
		let number: Double = 1234.563
		let numberFormattedString = "$1,234.563"
		let result = number.asCurrencyWith2Decimals()
		#expect(result != numberFormattedString)
	}

	struct TestCaseWith6Decimals {
		let number: Double
		let result: String

		static var all: [TestCaseWith6Decimals] {[
			.init(number: 1234.56, result: "$1,234.56"),
			.init(number: 12.3456, result: "$12.3456"),
			.init(number: 0.123456, result: "$0.123456"),
			.init(number: 0, result: "$0.00"),
			.init(number: 0.00, result: "$0.00"),
			.init(number: -0.00, result: "-$0.00"),
		]}
	}

	@Test(
		"Converts a Double into a Currency as a String with 2-6 decimal places",
		arguments: TestCaseWith6Decimals.all
	)
	func asCurrencyWith6Decimals(_ testCase: TestCaseWith6Decimals) async throws {
		#expect(testCase.number.asCurrencyWith6Decimals() == testCase.result)
	}

	struct TestCaseAsNumberString {
		let number: Double
		let result: String

		static var all: [TestCaseAsNumberString] {[
			.init(number: 1.2345, result: "1.23"),
			.init(number: 1.23, result: "1.23"),
			.init(number: 1.234, result: "1.23"),
			.init(number: 1.23445654546, result: "1.23"),
			.init(number: 1.2, result: "1.20"),
			.init(number: 1, result: "1.00"),
			.init(number: 0, result: "0.00"),
			.init(number: 0.01, result: "0.01"),
			.init(number: -0.01, result: "-0.01"),
		]}
	}

	@Test(
		"Converts a Double into string representation",
		arguments: TestCaseAsNumberString.all
	)
	func asNumberString(_ testCase: TestCaseAsNumberString) async throws {
		#expect(testCase.number.asNumberString() == testCase.result)
	}

	@Test(
		"Converts a Double into string representation with percent symbol",
		arguments: [
			(number: 1.2345, result: "1.23%"),
			(number: 1.234, result: "1.23%"),
			(number: 1.23445654546, result: "1.23%"),
			(number: 1.2, result: "1.20%"),
			(number: 1, result: "1.00%"),
			(number: 0, result: "0.00%"),
			(number: 0.01, result: "0.01%"),
			(number: -0.01, result: "-0.01%"),
			(number: 15, result: "15.00%"),
			(number: -4, result: "-4.00%")
	])
	func asPercentString(number: Double, result: String) async throws {
		#expect(number.asPercentString() == result)
	}

	@Test(
		"Convert a Double to a String with K, M, Bn, Tr abbreviations",
		arguments: [
			(value: 12, expected: "12.00"),
			(1234, "1.23K"),
			(123_456, "123.46K"),
			(12_345_678, "12.35M"),
			(1_234_567_890, "1.23Bn"),
			(123_456_789_012, "123.46Bn"),
			(12_345_678_901_234, "12.35Tr"),
			(-1234, "-1.23K"),
			(1000, "1.00K"),
			(999.99, "999.99"),
			(-0.5, "-0.50"),
			(-1234, "-1.23K"),
			(-12_345_678_901_234, "-12.35Tr")
		]
	)
	func formattedWithAbbreviations(value: Double, result: String) async throws {
		#expect(value.formattedWithAbbreviations() == result)
	}
}
