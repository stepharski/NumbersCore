//
//  FactsService.swift
//  NumbersCore
//
//  Created by Stepan Kukharskyi on 5/6/25.
//

import Foundation

// MARK: - FactsServiceProtocol
public protocol FactsServiceProtocol {
    func fetchSingleFact(number: Int) async throws -> FactListViewModel
    func fetchRandomFact() async throws -> FactListViewModel
    func fetchRangeFacts(min: Int, max: Int) async throws -> FactListViewModel
    func fetchMultipleFacts(numbers: [Int]) async throws -> FactListViewModel
}

// MARK: - FactsService
public final class FactsService: NetworkService, FactsServiceProtocol {
    // MARK: Properties
    private let storage = FactsStorage()

    // MARK: Init
    public override init() { }

    // MARK: Fetch Functionality
    public func fetchSingleFact(number: Int) async throws -> FactListViewModel {
        if let cached = storage.load(for: "\(number)") {
            return FactListViewModel(numbers: ["\(number)"], facts: [cached.text])
        }
        let route = ApiPath.singleFact(number: number)
        let fact: FactResponse = try await request(route)
        storage.save(fact)
        return FactListViewModel(numbers: ["\(fact.number)"], facts: [fact.text])
    }

    public func fetchRandomFact() async throws -> FactListViewModel {
        let route = ApiPath.randomFact
        let fact: FactResponse = try await request(route)
        return FactListViewModel(numbers: ["\(fact.number)"], facts: [fact.text])
    }

    public func fetchRangeFacts(min: Int, max: Int) async throws -> FactListViewModel {
        let keys = (min...max).map { "\($0)" }
        let missingKeys = storage.missingKeys(from: keys)
        if !missingKeys.isEmpty {
            let route = ApiPath.rangeFacts(min: min, max: max)
            let batch: BatchFactsResponse = try await request(route)
            storage.saveBatch(batch)
        }
        let cached = storage.loadSortedFacts(for: keys)
        let numbers = cached.map { $0.key }
        let facts = cached.map { $0.value.text }
        return FactListViewModel(numbers: numbers, facts: facts)
    }

    public func fetchMultipleFacts(numbers: [Int]) async throws -> FactListViewModel {
        let keys = numbers.map { "\($0)" }
        let missingKeys = storage.missingKeys(from: keys)
        if !missingKeys.isEmpty {
            let route = ApiPath.multipleFacts(numbers: numbers)
            let batch: BatchFactsResponse = try await request(route)
            storage.saveBatch(batch)
        }
        let cached = storage.loadSortedFacts(for: keys)
        let numbers = cached.map { $0.key }
        let facts = cached.map { $0.value.text }
        return FactListViewModel(numbers: numbers, facts: facts)
    }
}
