//
//  FactsStorage.swift
//  NumbersCore
//
//  Created by Stepan Kukharskyi on 5/6/25.
//

import Foundation

// MARK: - FactsStorage
final class FactsStorage {
    // MARK: Properties
    private var cache: [String: FactResponse] = [:]

    // MARK: Save Facts
    func save(_ fact: FactResponse) {
        cache["\(fact.number)"] = fact
    }

    func saveBatch(_ batch: BatchFactsResponse) {
        for (key, value) in batch.facts {
            let fact = FactResponse(
                text: value,
                number: Int(key) ?? .zero,
                found: true,
                type: "trivia")
            cache[key] = fact
        }
    }

    // MARK: Load Facts
    func load(for key: String) -> FactResponse? {
        return cache[key]
    }

    func missingKeys(from keys: [String]) -> [String] {
        return keys.filter { cache[$0] == nil }
    }
    
    func loadSortedFacts(for keys: [String]) -> [(key: String, value: FactResponse)] {
        var results: [(key: String, value: FactResponse)] = []
        keys.forEach {
            if let fact = cache[$0] { results.append(($0, fact)) }
        }
        results.sort { (Int($0.key) ?? 0) < (Int($1.key) ?? 0) }
        return results
    }

    // MARK: Clear Cache
    func clearCache() {
        cache.removeAll()
    }
}
