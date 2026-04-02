//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Roman Romanov on 28.03.2026.
//

import SwiftUI

@main
struct CryptoAppApp: App {

	@StateObject private var viewModel = HomeViewModel()

    var body: some Scene {
        WindowGroup {
			NavigationStack {
				HomeView()
					.toolbarVisibility(.hidden)
			}
			.environmentObject(viewModel)
        }
    }
}
