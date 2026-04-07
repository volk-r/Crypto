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
	@State private var showLaunchView: Bool = true

	init() {
		UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
		UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
		UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
	}

    var body: some Scene {
        WindowGroup {
			ZStack {
				NavigationStack {
					HomeView()
						.toolbarVisibility(.hidden)
				}
				.environmentObject(viewModel)

				ZStack {
					if showLaunchView {
						LaunchView(showLaunchView: $showLaunchView)
							.transition(.move(edge: .leading))
					}
				}
				.zIndex(2)
			}
        }
    }
}
