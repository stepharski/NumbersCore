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
    private var cache: [String: FactItem] = [:]

    // MARK: Save Facts
    func save(_ fact: FactItem) {
        cache["\(fact.number)"] = fact
    }

    func saveMulti(_ facts: [FactItem]) {
        facts.forEach {
            cache["\($0.number)"] = $0
        }
    }

    // MARK: Load Facts
    func load(for key: String) -> FactItem? {
        return cache[key]
    }

    func missingKeys(from keys: [String]) -> [String] {
        return keys.filter { cache[$0] == nil }
    }

    func loadMultiFacts(for keys: [String]) -> [FactItem] {
        var results = [FactItem]()
        keys.forEach {
            if let fact = cache[$0] { results.append(fact) }
        }
        results.sort { $0.number < $1.number }
        return results
    }

    // MARK: Clear Cache
    func clearCache() {
        cache.removeAll()
    }
}
