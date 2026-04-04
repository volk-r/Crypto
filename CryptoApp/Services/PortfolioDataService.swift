//
//  PortfolioDataService.swift
//  CryptoApp
//
//  Created by Roman Romanov on 04.04.2026.
//

import Combine
import CoreData
import Foundation

final class PortfolioDataService {

	// MARK: - Public Properties

	@Published var savedEntries: [PortfolioEntity] = []

	// MARK: - Private Properties

	private let container: NSPersistentContainer
	private let containerName: String = "PortfolioContainer"
	private let entityName: String = "PortfolioEntity"

	// MARK: - init

	init() {
		container = NSPersistentContainer(name: containerName)
		container.loadPersistentStores { _, error in
			if let error {
				print("Error loading Core Data! \(error)")
			}
			self.getPortfolio()
		}
	}

	// MARK: - Public Methods

	func updatePortfolio(coin: CoinModel, amount: Double) {
		if let entity = savedEntries.first(where: { $0.coinID == coin.id }) {
			if amount > 0 {
				update(entity: entity, amount: amount)
			} else {
				delete(entity: entity)
			}
		} else {
			add(coin: coin, amount: amount)
		}
	}
}

// MARK: - Private Methods

private extension PortfolioDataService {

	func getPortfolio() {
		let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
		do {
			savedEntries = try container.viewContext.fetch(request)
		} catch {
			print("Error fetching Portfolio Entities. \(error)")
		}
	}

	func add(coin: CoinModel, amount: Double) {
		let entity = PortfolioEntity(context: container.viewContext)
		entity.coinID = coin.id
		entity.amount = amount
		applyChanges()
	}

	func update(entity: PortfolioEntity, amount: Double) {
		entity.amount = amount
		applyChanges()
	}

	func delete(entity: PortfolioEntity) {
		container.viewContext.delete(entity)
		applyChanges()
	}

	func save() {
		do {
			try container.viewContext.save()
		} catch {
			print("Error saving to Core Data. \(error)")
		}
	}

	func applyChanges() {
		save()
		getPortfolio()
	}
}
