//
//  File.swift
//  NumbersCore
//
//  Created by Stepan Kukharskyi on 5/8/25.
//

import Foundation
@testable import NumbersCore

// MARK: - MockNetworkResponseType
enum MockNetworkResponseType {
    case valid
    case invalid
    case networkError
}

// MARK: - MockNetworkService
final class MockNetworkService: FactsServiceProtocol {
    // MARK: Properties
    var responseType: MockNetworkResponseType = .valid
    private let decoder = JSONDecoder()

    // MARK: Single Fact
    func fetchSingleFact(number: Int) async throws -> FactItem {
        var jsonURL: URL?
        switch responseType {
        case .valid:
            jsonURL = FactsJSONResponse.singleFactValid.url
        case .invalid:
            jsonURL = FactsJSONResponse.singleFactInvalid.url
        case .networkError:
            throw AppError.networkError
        }
        guard let jsonURL else { throw AppError.invalidURL }
        do {
            let data = try Data(contentsOf: jsonURL)
            let response = try decoder.decode(FactResponse.self, from: data)
            return response.toFactItem()
        } catch {
            throw AppError.invalidResponse
        }
    }

    // MARK: Random Fact
    func fetchRandomFact() async throws -> FactItem {
        var jsonURL: URL?
        switch responseType {
        case .valid:
            jsonURL = FactsJSONResponse.singleFactValid.url
        case .invalid:
            jsonURL = FactsJSONResponse.singleFactInvalid.url
        case .networkError:
            throw AppError.networkError
        }
        guard let jsonURL else { throw AppError.invalidURL }
        do {
            let data = try Data(contentsOf: jsonURL)
            let response = try decoder.decode(FactResponse.self, from: data)
            return response.toFactItem()
        } catch {
            throw AppError.invalidResponse
        }
    }

    // MARK: Range of Facts
    func fetchRangeFacts(min: Int, max: Int) async throws -> [FactItem] {
        var jsonURL: URL?
        switch responseType {
        case .valid:
            jsonURL = FactsJSONResponse.rangeFactsValid.url
        case .invalid:
            jsonURL = FactsJSONResponse.rangeFactsInvalid.url
        case .networkError:
            throw AppError.networkError
        }
        guard let jsonURL else { throw AppError.invalidURL }
        do {
            let data = try Data(contentsOf: jsonURL)
            let response = try decoder.decode([MultiFactResponse].self, from: data)
            return response.map { $0.toFactItem() }
        } catch {
            throw AppError.invalidResponse
        }
    }

    // MARK: Multiple Facts
    func fetchMultipleFacts(numbers: [Int]) async throws -> [FactItem] {
        var jsonURL: URL?
        switch responseType {
        case .valid:
            jsonURL = FactsJSONResponse.multipleFactsValid.url
        case .invalid:
            jsonURL = FactsJSONResponse.multipleFactsInvalid.url
        case .networkError:
            throw AppError.networkError
        }
        guard let jsonURL else { throw AppError.invalidURL }
        do {
            let data = try Data(contentsOf: jsonURL)
            let response = try decoder.decode([MultiFactResponse].self, from: data)
            return response.map { $0.toFactItem() }
        } catch {
            throw AppError.invalidResponse
        }
    }
}
