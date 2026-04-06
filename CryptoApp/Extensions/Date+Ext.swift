//
//  Date+Ext.swift
//  CryptoApp
//
//  Created by Roman Romanov on 06.04.2026.
//

import Foundation

extension Date {

	// "2021-03-13T20:49:26.606Z"
	init(coinGeckoString: String) {
		let date = AppDateFormatters.long.date(from: coinGeckoString) ?? Date()
		self.init(timeInterval: 0, since: date)
	}

	func asShortDateString() -> String {
		return AppDateFormatters.short.string(from: self)
	}
}
