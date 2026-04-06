//
//  AppNumberFormatters.swift
//  CryptoApp
//
//  Created by Roman Romanov on 30.03.2026.
//

import Foundation

enum AppNumberFormatters {

	/// Converts a Double into a Currency with 2 decimal places
	/// ```
	/// Convert 1234.56 to $1,234.56
	/// ```
	static let currencyFormatter2: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.usesGroupingSeparator = true
		formatter.numberStyle = .currency
		formatter.locale = AppContants.locale
		formatter.currencyCode = AppContants.currencyCode
		formatter.currencySymbol = AppContants.currencySymbol
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = 2
		return formatter
	}()

	/// Converts a Double into a Currency with 2-6 decimal places
	/// ```
	/// Convert 1234.56 to $1,234.56
	/// Convert 12.3456 to $12.3456
	/// Convert 0.123456 to $0.123456
	/// ```
	static let currencyFormatter6: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.usesGroupingSeparator = true
		formatter.numberStyle = .currency
		formatter.locale = AppContants.locale
		formatter.currencyCode = AppContants.currencyCode
		formatter.currencySymbol = AppContants.currencySymbol
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = 6
		return formatter
	}()
}
