//
//  SettingsView.swift
//  CryptoApp
//
//  Created by Roman Romanov on 07.04.2026.
//

import SwiftUI

struct SettingsView: View {

	let defaultURL = URL(string: "https://github.com/volk-r")!
	let habrURL = URL(string: "https://habr.com/ru/articles/1010642/")!
	let githubURL = URL(string: "https://github.com/volk-r/CryptoApp")!
	let coingeckoURL = URL(string: "https://docs.coingecko.com/websocket/cgsimpleprice")!
	let persionalURL = URL(string: "https://github.com/volk-r?tab=repositories")!

    var body: some View {
		NavigationStack {
			List {
				descriptionSection
					.listRowBackground(Color.theme.accent.opacity(0.1))
				coingeckoSection
					.listRowBackground(Color.theme.accent.opacity(0.1))
				developerSection
					.listRowBackground(Color.theme.accent.opacity(0.1))
			}
			.scrollContentBackground(.hidden)
			.background(Color.theme.background)
			.font(.headline)
			.tint(.blue)
			.listStyle(.grouped)
			.navigationTitle("Settings")
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					XMarkButton()
				}
			}
		}
    }
}

private extension SettingsView {

	var descriptionSection: some View {
		Section(header: Text("Application").foregroundStyle(Color.theme.accent)) {
			VStack(alignment: .leading) {
				Image(.Images.logo)
					.resizable()
					.frame(width: 100, height: 100)
					.clipShape(RoundedRectangle(cornerRadius: 20))
				Text("This app was made for informational purposes, without the right to commercial use by third parties. It uses MVVM Architecture, Combine, Core Data and Swift Charts!")
					.font(.callout)
					.fontWeight(.medium)
					.foregroundStyle(Color.theme.accent)
					.padding(.top, 6)
			}
			.padding(.vertical, 4)
			Link("Subscribe on Github 🥳", destination: defaultURL)
			Link("Support the author's endeavors 🔥", destination: habrURL)
		}
	}

	var coingeckoSection: some View {
		Section(header: Text("Coingecko").foregroundStyle(Color.theme.accent)) {
			VStack(alignment: .leading) {
				Image(.Images.coingecko)
					.resizable()
					.scaledToFit()
					.frame(height: 100)
					.clipShape(RoundedRectangle(cornerRadius: 20))
				Text("The cryptocurrency data that is used in in this app comes from a free API from Coingecko! Prices may be slightly delayed.")
					.font(.callout)
					.fontWeight(.medium)
					.foregroundStyle(Color.theme.accent)
					.padding(.top, 6)
			}
			.padding(.vertical, 4)
			Link("Visit Coingecko 🦎", destination: coingeckoURL)
		}
	}

	var developerSection: some View {
		Section(header: Text("Developer").foregroundStyle(Color.theme.accent)) {
			VStack(alignment: .leading) {
				Image(.Images.volkR)
					.resizable()
					.frame(width: 100, height: 100)
					.clipShape(RoundedRectangle(cornerRadius: 20))
				Text("This app was developed by Roman Romanov. It uses SwiftUI and is written 100% in Swift. The project benefits from multi-threading, publishers/subscribers, data persistence and Swift's powerful async/await. The code is open source and available on GitHub.")
					.font(.callout)
					.fontWeight(.medium)
					.foregroundStyle(Color.theme.accent)
					.padding(.top, 6)
			}
			.padding(.vertical, 4)
			Link("Visit Website ⭐️", destination: persionalURL)
			Link("Project on GitHub 🐺", destination: githubURL)
		}
	}
}

#Preview {
	NavigationStack {
		SettingsView()
	}
}
