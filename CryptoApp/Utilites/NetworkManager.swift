//
//  NetworkManager.swift
//  CryptoApp
//
//  Created by Roman Romanov on 01.04.2026.
//

import Combine
import Foundation

final class NetworkManager {

	enum NetworkError: LocalizedError {
		case badURLResponse(url: URL)
		case unknown

		var errorDescription: String? {
			switch self {
			case .badURLResponse(let url): return "[🔥] Bad response from URL: \(url)"
			case .unknown: return "[⚠️] Unknown error occurred"
			}
		}
	}

	static func download(url: URL) -> AnyPublisher<Data, Error> {
		URLSession.shared.dataTaskPublisher(for: url)
			.tryMap { try handleURLResponse(output: $0, url: url) }
			.retry(3)
			.eraseToAnyPublisher()
	}

	static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
		guard
			let response = output.response as? HTTPURLResponse,
			200 ..< 300 ~= response.statusCode
		else {
			throw NetworkError.badURLResponse(url: url)
		}
		return output.data
	}

	static func handleCompletion(completion: Subscribers.Completion<Error>) {
		switch completion {
		case .finished:
			break
		case .failure(let error):
			print(error.localizedDescription)
		}
	}
}
