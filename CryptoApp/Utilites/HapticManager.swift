//
//  HapticManager.swift
//  CryptoApp
//
//  Created by Roman Romanov on 04.04.2026.
//

import SwiftUI

final class HapticManager {

	static private let generator = UINotificationFeedbackGenerator()

	static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
		generator.notificationOccurred(type)
	}
}
