//
//  FactsService.swift
//  NumbersCore
//
//  Created by Stepan Kukharskyi on 5/6/25.
//

import Foundation

// MARK: - FactsServiceProtocol
public protocol FactsServiceProtocol {
    func fetchSingleFact(number: Int) async throws -> FactItem
    func fetchRandomFact() async throws -> FactItem
    func fetchRangeFacts(min: Int, max: Int) async throws -> [FactItem]
    func fetchMultipleFacts(numbers: [Int]) async throws -> [FactItem]
}

// MARK: - FactsService
public final class FactsService: FactsServiceProtocol {
    // MARK: Properties
    private let storage = FactsStorage()
    private let networkService = NetworkService()

    // MARK: Init
    public init() { }

    // MARK: Fetch Functionality
    public func fetchSingleFact(number: Int) async throws -> FactItem {
        if let cached = storage.load(for: "\(number)") {
            return cached
        }
        let route = ApiPath.singleFact(number: number)
        let response: FactResponse = try await networkService.request(route)
        let fact = response.toFactItem()
        storage.save(fact)
        return fact
    }

    public func fetchRandomFact() async throws -> FactItem {
        let route = ApiPath.randomFact
        let response: FactResponse = try await networkService.request(route)
        return response.toFactItem()
    }

    public func fetchRangeFacts(min: Int, max: Int) async throws -> [FactItem] {
        let keys = (min...max).map { "\($0)" }
        let missingKeys = storage.missingKeys(from: keys)
        if !missingKeys.isEmpty {
            let route = ApiPath.rangeFacts(min: min, max: max)
            let batch: [MultiFactResponse] = try await networkService.request(route)
            let facts = batch.map { $0.toFactItem() }
            storage.saveMulti(facts)
        }
        return storage.loadMultiFacts(for: keys)
    }

    public func fetchMultipleFacts(numbers: [Int]) async throws -> [FactItem] {
        let keys = numbers.map { "\($0)" }
        let missingKeys = storage.missingKeys(from: keys)
        if !missingKeys.isEmpty {
            let route = ApiPath.multipleFacts(numbers: numbers)
            let batch: [MultiFactResponse] = try await networkService.request(route)
            let facts = batch.map { $0.toFactItem() }
            storage.saveMulti(facts)
        }
        return storage.loadMultiFacts(for: keys)
    }
}

// MARK: - Sendable
extension FactsService: @unchecked Sendable { }
