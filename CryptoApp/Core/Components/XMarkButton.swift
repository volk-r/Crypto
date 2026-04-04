//
//  XMarkButton.swift
//  CryptoApp
//
//  Created by Roman Romanov on 03.04.2026.
//

import SwiftUI

struct XMarkButton: View {

	@Environment(\.dismiss) private var dismiss

	var body: some View {
		Button(action: {
			dismiss()
		}, label: {
			Image(systemName: "xmark")
				.font(.headline)
		})
	}
}

#Preview {
	XMarkButton()
}
