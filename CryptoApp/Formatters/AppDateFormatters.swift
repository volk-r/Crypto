//
//  AppDateFormatters.swift
//  CryptoApp
//
//  Created by Roman Romanov on 06.04.2026.
//

import Foundation

enum AppDateFormatters {

	static let long: DateFormatter = {
		let formatter = DateFormatter()
		formatter.locale = AppContants.locale
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		return formatter
	}()

	static let short: DateFormatter = {
		let formatter = DateFormatter()
		formatter.locale = AppContants.locale
		formatter.dateStyle = .short
		return formatter
	}()
}
