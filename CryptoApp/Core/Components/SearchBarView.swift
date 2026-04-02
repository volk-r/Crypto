//
//  SearchBarView.swift
//  CryptoApp
//
//  Created by Roman Romanov on 02.04.2026.
//

import SwiftUI

struct SearchBarView: View {

	@Binding var searchText: String

	@FocusState private var isFocused: Bool

    var body: some View {
		HStack {
			Image(systemName: "magnifyingglass")
				.foregroundStyle(
					searchText.isEmpty
					? Color.theme.secondaryText
					: Color.theme.accent
				)

			TextField("Search by name or symbols...", text: $searchText)
				.foregroundStyle(Color.theme.accent)
				.keyboardType(.asciiCapable)
				.autocorrectionDisabled()
				.focused($isFocused)

			VStack(alignment: .trailing) {
				Image(systemName: "xmark.circle.fill")
					.foregroundStyle(Color.theme.accent)
					.opacity(searchText.isEmpty ? 0 : 1)
					.onTapGesture {
						searchText = ""
						isFocused = false
					}
			}
		}
		.font(.headline)
		.padding()
		.background {
			RoundedRectangle(cornerRadius: 25)
				.fill(Color.theme.background)
				.shadow(color: Color.theme.accent.opacity(0.15), radius: 10)
		}
		.padding()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
	SearchBarView(searchText: .constant(""))
		.colorScheme(.light)
}
