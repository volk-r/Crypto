//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Roman Romanov on 28.03.2026.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    var body: some Scene {
        WindowGroup {
			NavigationStack {
				HomeView()
			}
			.toolbarVisibility(.hidden)
        }
    }
}
