//
//  NetworkManagerUnitTests.swift
//  CryptoAppUnitTests
//
//  Created by Roman Romanov on 10.04.2026.
//

import Combine
import Foundation
import Testing
@testable import CryptoApp

struct NetworkManagerUnitTests {

	private let url = URL(string: "https://example.com/resource")!

	@Test("handleURLResponse returns data for HTTP 200")
	func handleURLResponse_success200() throws {
		let payload = Data("ok".utf8)
		let response = HTTPURLResponse(
			url: url,
			statusCode: 200,
			httpVersion: nil,
			headerFields: nil
		)!
		let output: URLSession.DataTaskPublisher.Output = (data: payload, response: response)
		let result = try NetworkManager.handleURLResponse(output: output, url: url)
		#expect(result == payload)
	}

	@Test("handleURLResponse returns data for HTTP 299")
	func handleURLResponse_success299() throws {
		let payload = Data()
		let response = HTTPURLResponse(
			url: url,
			statusCode: 299,
			httpVersion: nil,
			headerFields: nil
		)!
		let output: URLSession.DataTaskPublisher.Output = (data: payload, response: response)
		let result = try NetworkManager.handleURLResponse(output: output, url: url)
		#expect(result == payload)
	}

	@Test("handleURLResponse throws for HTTP 404")
	func handleURLResponse_failure404() {
		let response = HTTPURLResponse(
			url: url,
			statusCode: 404,
			httpVersion: nil,
			headerFields: nil
		)!
		let output: URLSession.DataTaskPublisher.Output = (data: Data(), response: response)
		#expect(throws: NetworkManager.NetworkError.self) {
			try NetworkManager.handleURLResponse(output: output, url: url)
		}
	}

	@Test("handleURLResponse throws for non-HTTP response")
	func handleURLResponse_nonHTTPResponse() {
		let response = URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
		let output: URLSession.DataTaskPublisher.Output = (data: Data(), response: response)
		#expect(throws: NetworkManager.NetworkError.self) {
			try NetworkManager.handleURLResponse(output: output, url: url)
		}
	}
}
