//
//  BatchFactsResponse.swift
//  NumbersCore
//
//  Created by Stepan Kukharskyi on 5/6/25.
//

import Foundation

// MARK: - BatchFactsResponse
struct BatchFactsResponse: Codable {
    let facts: [String: String]

    init(facts: [String: String]) {
        self.facts = facts
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.facts = try container.decode([String : String].self)
    }

    var sortedFacts: [(key: String, value: String)] {
        facts.sorted { (Int($0.key) ?? 0) < (Int($1.key) ?? 0) }
    }

    var sortedKeys: [String] {
        sortedFacts.map { $0.key }
    }

    var sortedValues: [String] {
        sortedFacts.map { $0.value }
    }
}
