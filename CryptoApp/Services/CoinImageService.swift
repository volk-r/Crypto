//
//  CoinImageService.swift
//  CryptoApp
//
//  Created by Roman Romanov on 01.04.2026.
//

import Combine
import SwiftUI

final class CoinImageService: ObservableObject {

	@Published var image: UIImage?

	private var imageSubscription: AnyCancellable?
	private let coin: CoinModel

	private let fileManager = LocalFileManager.instance
	private let folderName: String
	private let imageName: String

	init(coin: CoinModel, folderName: String = "coin_images") {
		self.coin = coin
		self.folderName = folderName
		self.imageName = coin.id

		getCoinImage()
	}

	private func getCoinImage() {
		if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
			image = savedImage
		} else {
			downloadCoinImage()
		}
	}

	private func downloadCoinImage() {
		guard let url = URL(string: coin.image) else { return }

		imageSubscription = NetworkManager.download(url: url)
			.tryMap { (data) -> UIImage? in UIImage(data: data) }
			.receive(on: DispatchQueue.main)
			.sink { completion in
				NetworkManager.handleCompletion(completion: completion)
			} receiveValue: { [weak self] returnedImage in
				guard let self, let returnedImage else { return }
				self.image = returnedImage
				self.imageSubscription?.cancel()
				self.fileManager.saveImage(image: returnedImage, imageName: imageName, folderName: folderName)
			}
	}
}
