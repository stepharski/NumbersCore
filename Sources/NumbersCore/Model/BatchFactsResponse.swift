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

    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.facts = try container.decode([String : String].self)
    }
}
